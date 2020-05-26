Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB6A1E2A37
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 20:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389038AbgEZSjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 14:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388499AbgEZSjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 14:39:43 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52B3C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 11:39:42 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id er16so9971593qvb.0
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 11:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eQTGChqEmy0fKXATRtTMTxXbR+GNDT6t8G1XVc1+7qE=;
        b=H+FKu7OKmnxDIZUkDtUtwHEBmlYGi1Tzz+XGhpW5y5YU3YEvFHYe2VWIQVnqWOGG3F
         f1V8eaeKH3Fj1e2HQiwy4kIIgKn3yaSHF5ael0dur+XJ/rbqWtYnDE9V4SHmEsESzkTd
         IK/h1Tb+ieqjsfFZHQIf85c/S6fJq1IfKgDkZZU6hnPSXrd7Fk7qc4Qz4QhKYQWoDaF1
         6EiJZg574+sj43xZtD8x5GEDyizq2JDoE+X/ym6Qu0k0S/NMFDYEDaIU7iCnpM678aIt
         X6xa7A9X80RLdromk2WXBfCNSGcbcmwz747bWOS+yh3NCPlixzN6dUXUYBk0Wkb3x9r9
         bsfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eQTGChqEmy0fKXATRtTMTxXbR+GNDT6t8G1XVc1+7qE=;
        b=FLdZc0q39etvi/OhWCeRP9TAnRhlavD8XbBz007TWEjMY3Oj8N9yQSn0CrLpz/LbOQ
         Mf8EsjVqs5sFlO+5MF41WRieyfGjvGt2wvJRXjdacAIt0XxFeYIWckQDrxeeu0rWDZ80
         A9SCgttkoSmpLl7xLXAiD6tNZ2+xOpqeQaZkirlrmebSsqvOt6emz3o+0j0G6ba/FEvu
         c2ZFnKzu/HiVFgQNqMnw6a9IxEEYziuy3H/v6smasI0mRePUpw4po0lXkPSabuBQrbtR
         g0SBBBoWKjiPnpYTtvOX7W7tpsiXg+jd+ZgQyaet/in/lkxwxdCvT5OcRW0NehiJV0eL
         clGQ==
X-Gm-Message-State: AOAM5306lgZ+8Wkv95gusSuhaGqy045Sb0LfFohyrz97eoL5Zkrd/wrg
        Ohr4yw5OFThP2R2b1WVWWno=
X-Google-Smtp-Source: ABdhPJx6nn8hB8dzJOW3WDGTWuKBms7sBq0O/7dIiprwOh3kEd07FWkENSJxBi01idLv03H4A5JWDA==
X-Received: by 2002:a05:6214:1365:: with SMTP id c5mr20191000qvw.152.1590518382237;
        Tue, 26 May 2020 11:39:42 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id u16sm369800qkm.107.2020.05.26.11.39.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 11:39:41 -0700 (PDT)
Subject: Re: [PATCH net 5/5] ipv4: nexthop version of fib_info_nh_uses_dev
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        nikolay@cumulusnetworks.com
References: <20200526150114.41687-1-dsahern@kernel.org>
 <20200526150114.41687-6-dsahern@kernel.org>
 <20200526113754.0d0a64f2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <642dbb4c-1423-f83d-ad56-7efc2cb2848a@gmail.com>
Date:   Tue, 26 May 2020 12:39:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526113754.0d0a64f2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/20 12:37 PM, Jakub Kicinski wrote:
> Dave, bunch of white space problems here according to checkpatch:
> 

ugh, the VM I used for iterations did not have the git hook to run
checkpatch on commit. Will re-spin.
