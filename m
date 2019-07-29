Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFDA799BF
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbfG2UR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:17:29 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:43414 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbfG2UR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:17:29 -0400
Received: by mail-pg1-f181.google.com with SMTP id r22so1201511pgk.10
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 13:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TWScV76foyUH5FRqS7mI8GkQ8NHbwbBCm5vYu0HZCRA=;
        b=YL8hkjmahFxKmQe9GQn4zZgiOqTLOHj4Tq+9neWMLm2hZqr3jrYLiItt+T1RZpDOdR
         Dt4eSSJhRZhCYnGQ94mNX/A8Sq7rmwEu6XbjuRvOueYcV67tpSxGD7wYYY20tZa7uxrQ
         iA+K6zovQyp3wUywwrYY/Xn+IclvZsTEifyZKkqnxq5L3O0/LSyFLa5gdVLYYZywsGel
         m7T1URAPTDcTcmNMIvVqdEW9eLR2sj3t7QYuYMO0Uza4jREc4iK97jp8AqKCFlgIbOQb
         C8HU+6KJFCo/y8hFx2UzV8P6kXIt7q3/fjfSCh0gBpxdxxDI/RyN8hTMc+/sC8SsAp5W
         qA5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TWScV76foyUH5FRqS7mI8GkQ8NHbwbBCm5vYu0HZCRA=;
        b=k2UUc6XnctsZZjQ4AScWBAcZlhK+6uqCyP+6psq0z8MVgs5rSJ5USQ84sN0OG+b2tu
         VMo+CjpjHbthYpZPd4CXm7me2sxtHQtnf/HDp8W4v35Cra98tp/vD9FGcp+K63dqKTHh
         jvNNgeEVKbnlSe7zKbkVsdNehiPDYi1O0enOupFDseErU5YMVS91aRI2RH/m3FtaMfF4
         tv+8Vyo+fyP3PU/srlTNvPxc4I0NObeV7zUDF6ssLPMw5IFWAYL3sfmSs/tQ61Z3i2CB
         mvkiZWkTRSkaRGnDU4cZPFdNErlHRVmUb+R0Bp3SLb8WNb5yPwz/PnFEaQKUbY40MuBU
         KJfA==
X-Gm-Message-State: APjAAAWlLv86PhSS1jsrDmzge/OI8xf8zlJT3mA5D7dT7ytnEBGXQN90
        yZ+XdByPugTSdzYt/4Gq6s0=
X-Google-Smtp-Source: APXvYqwh/zvAyb5LQZV2AFxBNqYoZ3M2665GQWX6m318MYlFrzZfabutEayzUCUwj/x97a+h9AqOwA==
X-Received: by 2002:a63:4612:: with SMTP id t18mr97126824pga.85.1564431448359;
        Mon, 29 Jul 2019 13:17:28 -0700 (PDT)
Received: from [172.27.227.219] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id b19sm58883899pgh.57.2019.07.29.13.17.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 13:17:27 -0700 (PDT)
Subject: Re: [patch net-next 0/3] net: devlink: Finish network namespace
 support
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, mlxsw@mellanox.com
References: <20190727094459.26345-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <eebd6bc7-6466-2c93-4077-72a39f3b8596@gmail.com>
Date:   Mon, 29 Jul 2019 14:17:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190727094459.26345-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/19 3:44 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Devlink from the beginning counts with network namespaces, but the
> instances has been fixed to init_net. The first patch allows user
> to move existing devlink instances into namespaces:
> 

so you intend for an asic, for example, to have multiple devlink
instances where each instance governs a set of related ports (e.g.,
ports that share a set of hardware resources) and those instances can be
managed from distinct network namespaces?

