Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70ED9192E92
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgCYQqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:46:10 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34251 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgCYQqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 12:46:09 -0400
Received: by mail-qk1-f196.google.com with SMTP id i6so3292875qke.1
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 09:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=X06tsSI5Kzb28+BZI8/YNITti/1/GemGG9r5AbFCAvs=;
        b=KLqC3J57uyf7O5+qg3EtMMgsxkrBkwjfNWaJBY2EiMTF562ageWgm3yqHqEXCrkD7y
         G86WjJWE8Bf6BMNfHKbb3MR2m/AqZnz98GweM8V+sXHZp2ylG8EVZRhz43OcDfayY0kS
         WXYu7Ux88DsS6NxrhAxp6Tp3TpiERE9TjISSWoQsrjb4314qu6olWn2DHSl1YkxTUMHN
         R1bcFw4KVTf0fjIMosJlDRvc4m+4qNRgEB+7yd8P8CZlyEYcNwpG1sgyFfuNC9Y5xE9M
         8qjzE/rCB5lQSX4n+jY0VtbBltf+JZ2J5ydK1k8dyAwjhgZ5CI/CAlWGgUzHH6bg3PfR
         i77w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X06tsSI5Kzb28+BZI8/YNITti/1/GemGG9r5AbFCAvs=;
        b=uXWzVug71ySK+mU34olyXQm9PvqpOjQHi9VVokFVbKFBhQEqr4JjGe0AO96swd5f2r
         UydelfLfuL8MwWlEdI6O3ti8Z02QEBWbUW5q5Vm/W8KMsaFhF8nAM9NZ+F0TcLIowWut
         thRy5dGQhlpnhH4lp9Ayv7R9wCxAYrudUOtmL5oh+lRyX3f8J1JQ34ozyalfmU06R041
         EYVGX/+KTh0CNS8Ha/a2/LYU+ZkzdJ3VZPWZ8t+eCAU4s+Gsfj8RqUloVYDswlhRDkqC
         n52l8x4LG/gFDEOe7jYMrrDJQdobLKMtfGEdFvnSUgrxhYRH2hUsfvZSNTjDVTyxZuEh
         4WgA==
X-Gm-Message-State: ANhLgQ2jtE6cdm6Wuzw0JrAxHFb+SzIvW3r+NiboMq5/dEwyB2My4Tja
        Ushm7Zsqi0AjANmtXCnw3iYAaAs2
X-Google-Smtp-Source: ADFU+vviuv+ULuHzjP0k/tMKs+7ivaT3N4vc3ZYYWdffKVpWNGBugVgEmA6LVnh83lWmMkAfbeGSlg==
X-Received: by 2002:a05:620a:14d:: with SMTP id e13mr3930931qkn.470.1585154766410;
        Wed, 25 Mar 2020 09:46:06 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:5593:7720:faa1:dac9? ([2601:282:803:7700:5593:7720:faa1:dac9])
        by smtp.googlemail.com with ESMTPSA id r46sm17580563qtb.87.2020.03.25.09.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 09:46:05 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 2/2] tc: q_red: Support 'nodrop' flag
To:     Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org
References: <cover.1584979543.git.petrm@mellanox.com>
 <00c7299b47f6b089e79245040484de106254016e.1584979543.git.petrm@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ba43843c-5528-9807-c225-b67dfe2a4788@gmail.com>
Date:   Wed, 25 Mar 2020 10:46:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <00c7299b47f6b089e79245040484de106254016e.1584979543.git.petrm@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/20 10:12 AM, Petr Machata wrote:
> Recognize the new configuration option of the RED Qdisc, "nodrop". Add
> support for passing flags through TCA_RED_FLAGS, and use it when passing
> TC_RED_NODROP flag.
> 
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> ---
> 

applied to iproute2-next. Thanks


