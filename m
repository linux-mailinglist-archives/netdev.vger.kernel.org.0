Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20322ECD0A
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 04:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfKBDV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 23:21:58 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43797 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfKBDV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 23:21:58 -0400
Received: by mail-pl1-f193.google.com with SMTP id a18so4011728plm.10;
        Fri, 01 Nov 2019 20:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pTILKw4L+RzXCLEIksYyx7zZPBhtM+w2VRMhfIxEgps=;
        b=rms5K3KCV+P0yXSBTXAwFaNDOnvKhQctsz6gKaHPYHnKVwbfTYCm4/CDmXxQiMmkWJ
         ECqII19rDEKzS/qErzo3ZQiymbPG7G6/lP/X+gAKILif46adZ8Wo0Fuk6nki7GBvhVQm
         34IAi5iSITDztPIgtrgQqtYbYBfJhj7g8caP8BJhk7m/YwgPEP58LTsd1UK1T8Uf73dy
         KVJB7ZaURSk9aQLF7/EosW4jhlU1rUuFukvHzv8a5iAOX6VKxUyCFGKWscRlT8AqkrEW
         U8hDNFpp1L12KNNKnW6OkRWFeTooO4rIi+Z8MNtM4ksq+vJ2+kIRkiThJgskaWbFVlsl
         WfxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pTILKw4L+RzXCLEIksYyx7zZPBhtM+w2VRMhfIxEgps=;
        b=rW8FIT92dxjFd7qkFUvgEU4CYCivqRZZz3v4Zj1ZWFBaNvz0bJqyBti4sKewTkRFw8
         bRLvblBdnENaM76+uYRWQ/0NvT4+UOkoNzQyoceERIcur9N7mEJKQ+YRljUNMgtPOp8o
         Cgd8/EINOMhJMzh1yjTMRvWtZO5JbpVSgGjbRGk290RluURHcncy8lSDUIcNRq+ZC+AY
         2Aas6FTepPfc+PB0J0zrb+qm26AEkI0ZWKifd5sPfeC9howMbpCsmyV0kFwm1bVeMvq3
         yLoeNqhWWn0UPZyVJERM61cNlUggzTHFuHWB9oH8PTDZJZzTU3vwyqGnjVyRY0keMMQN
         b0EA==
X-Gm-Message-State: APjAAAVoIB8lsTMmWDYE2q/F3x5VFCYANTc17U4R2SMijAs/LRmBsW8w
        jAFLnJNeH5yp8l9K7R0NAN1dKXdQ
X-Google-Smtp-Source: APXvYqzcuyCu+UxBRNcSgARKkE4UIe8DvGh1IcANgxy3orwmhXfobbFs0yoUeoAJwprHeVCXfc/cog==
X-Received: by 2002:a17:902:a581:: with SMTP id az1mr15777696plb.311.1572664917221;
        Fri, 01 Nov 2019 20:21:57 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id d5sm10872870pfa.180.2019.11.01.20.21.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 20:21:56 -0700 (PDT)
Subject: Re: [PATCH 5/5] net: phy: at803x: fix the PHY names
To:     Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
References: <20191102011351.6467-1-michael@walle.cc>
 <20191102011351.6467-6-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <239b7940-d96c-d5e5-f029-292d55e7e4b1@gmail.com>
Date:   Fri, 1 Nov 2019 20:21:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191102011351.6467-6-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2019 6:13 PM, Michael Walle wrote:
> Fix at least the displayed strings. The actual name of the chip is
> AR803x.

Only if you have to spin a v2, since you fixed the Kconfig entry, you
might as well fix those names to be Qualcomm Atheros.
--
Florian
