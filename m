Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A17378ACF
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 14:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbhEJLwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 07:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241597AbhEJLiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 07:38:24 -0400
X-Greylist: delayed 2404 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 10 May 2021 04:32:56 PDT
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC8CC0610D5;
        Mon, 10 May 2021 04:32:56 -0700 (PDT)
Received: from ip4d14bd53.dynamic.kabel-deutschland.de ([77.20.189.83] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1lg3Wn-0008EG-Lc; Mon, 10 May 2021 12:52:45 +0200
Subject: Re: [PATCH 00/53] Get rid of UTF-8 chars that can be mapped as ASCII
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fpga@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-media@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org, x86@kernel.org
References: <cover.1620641727.git.mchehab+huawei@kernel.org>
From:   Thorsten Leemhuis <linux@leemhuis.info>
Message-ID: <c4479ced-f4d8-1a1e-ee54-9abc55344187@leemhuis.info>
Date:   Mon, 10 May 2021 12:52:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <cover.1620641727.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-BS
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1620646377;def39258;
X-HE-SMSGID: 1lg3Wn-0008EG-Lc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10.05.21 12:26, Mauro Carvalho Chehab wrote:
>
> As Linux developers are all around the globe, and not everybody has UTF-8
> as their default charset, better to use UTF-8 only on cases where it is really
> needed.
> […]
> The remaining patches on series address such cases on *.rst files and 
> inside the Documentation/ABI, using this perl map table in order to do the
> charset conversion:
> 
> my %char_map = (
> […]
> 	0x2013 => '-',		# EN DASH
> 	0x2014 => '-',		# EM DASH

I might be performing bike shedding here, but wouldn't it be better to
replace those two with "--", as explained in
https://en.wikipedia.org/wiki/Dash#Approximating_the_em_dash_with_two_or_three_hyphens

For EM DASH there seems to be even "---", but I'd say that is a bit too
much.

Or do you fear the extra work as some lines then might break the
80-character limit then?

Ciao, Thorsten
