Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55FE1B1D5A
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 06:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgDUEXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 00:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbgDUEXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 00:23:44 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89ABDC061A0F
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 21:23:42 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id t11so6193941pgg.2
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 21:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:autocrypt:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ap5jnMANbFlSzpYdy5IS7rKJfWqsR39yrWdAUHTz+K8=;
        b=cGuI60hyJbjydoLFnE9Rhjq94/r2rCpb2p6ZsO1dL6Rp+PIfeu6SgIHZG4lM+GEj1Q
         LYvPw2YgLosLLYdEEYqyqGP0Z/tqu140JKOpuIPN0TurRKae+3f9VvUodGPgA/OnsifC
         hN8e4MwhFyAn6ZBk2hWsrNSh3EK2fmtOhv0+5givCKDx6WEEG/cfQu1HFyYxZQUlHcB2
         YaQX1dI1gjDgn7M3XQ2Avj03IAD8+co78aDPKJlm00uSQRJHv2Q3H/O5HxS4UztR+jxa
         5cJmqR3p9ioNorXFQhz6IS1LoBj74LB1qPgpsmOkEz276Kt8QVHFSvWbZ09U80yYqxQZ
         bvXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:autocrypt:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=ap5jnMANbFlSzpYdy5IS7rKJfWqsR39yrWdAUHTz+K8=;
        b=Wvh3/oJ2v/VpKb3Oqg0SEjvsQe8Cx5X1Bhjyx4surmpZyhjQt+xkh2juErMdbW/qNn
         DbxCfx9l3146Xfdjv+Ye8cssVKOSWLDvhZwebjtBus0hWYGMVQaO8xLuq21P7QoazEfP
         a3kE5Vybmng2nrvbLKtNrt+/F/IwEiWfYMIu9M4G5O69WpgwIsOLL3SjvuodB5rLU7U7
         TGtSUhljtLYpZanxZTwrzmY35blemqtjP0LFqi6UVqAqe7oGi09N43sH95KmrIoKdQmP
         6KWJuZ0EATNLLJtVMgAsTcZWiGY7it5Lw88FXiTDGe1hpo+XtWKFfUEM2MU/sv8IgwBM
         EvSg==
X-Gm-Message-State: AGi0PuZzMAgrW6JXVH35Mp2OJP2OVaKHyyf4RMo+RdAREf2QAraVVBXr
        xoZys+fjCv3/i9pKoOT553GH4Q==
X-Google-Smtp-Source: APiQypLPMAQRcB6Izv/8cVZB/mFHVhiYHx6XhC8HuTpWpsekFVdGCoHodSyarK/3w+s6O7LPHOWR4g==
X-Received: by 2002:a62:3381:: with SMTP id z123mr6085402pfz.274.1587443022008;
        Mon, 20 Apr 2020 21:23:42 -0700 (PDT)
Received: from [192.168.10.94] (124-171-87-207.dyn.iinet.net.au. [124.171.87.207])
        by smtp.gmail.com with ESMTPSA id e4sm947486pge.45.2020.04.20.21.23.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 21:23:41 -0700 (PDT)
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: mlx5_core irisc not responding
Autocrypt: addr=aik@ozlabs.ru; keydata=
 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
Message-ID: <ea3bde05-2b49-e985-5cb2-ecdda87fb3a5@ozlabs.ru>
Date:   Tue, 21 Apr 2020 14:23:38 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

I got a Mellanox CX4 card constantly complaining  about "irisc not
responding" (below). Is there a way to get a better idea what it is
unhappy about? It is plugged to an experimental POWER9 box which might
have PCI problems. The kernel is v5.6.0.

I thought I try updating the firmware first but mlxup refuses to update
the firmware as it is an OEM adapter (below); and there is no way to
find out which Mellanox PSID corresponds to what I got, any hints? Thanks,



The device is:

root@ltcssss2:~# mstflint -d 0001:19:00.0 q
Image type:            FS3
FW Version:            14.26.0226
FW Release Date:       4.8.2019
Product Version:       6.0226
Description:           UID                GuidsNumber
Base GUID:             0894ef030080a89f        8
Base MAC:              00000894ef80a89f        8
Image VSD:             N/A
Device VSD:            N/A
PSID:                  IBM0000000034
Security Attributes:   N/A


root@ltcswift2:~# ./mlxup
Querying Mellanox devices firmware ...
    Device #1:

----------
      Device Type:      ConnectX4LX

  Part Number:      IBM_CX4LX_2p_10GE_x4_Ax
  Description:      ConnectX-4 LX 10 and 1 G-BaseT dual-port BP; PCIe3.0 x4;
  PSID:             IBM0000000034
  PCI Device Name:  0001:19:00.0
  Base MAC:         0894ef80a89f
  Versions:         Current        Available
     FW             14.26.0226     N/A             Status:           No
matching image found


dmesg (the same for :0001:19:00.1):

[   13.283418] mlx5_core 0001:19:00.0: print_health_info:374:(pid 0):
assert_var[0] 0x00000001
[   13.283447] mlx5_core 0001:19:00.0: print_health_info:374:(pid 0):
assert_var[1] 0x0087f14c
[   13.283481] mlx5_core 0001:19:00.0: print_health_info:374:(pid 0):
assert_var[2] 0x00000000
[   13.283535] mlx5_core 0001:19:00.0: print_health_info:374:(pid 0):
assert_var[3] 0x01020000
[   13.283588] mlx5_core 0001:19:00.0: print_health_info:374:(pid 0):
assert_var[4] 0x00000000
[   13.283631] mlx5_core 0001:19:00.0: print_health_info:377:(pid 0):
assert_exit_ptr 0x0080e428
[   13.283667] mlx5_core 0001:19:00.0: print_health_info:379:(pid 0):
assert_callra 0x0080e070
[   13.283726] mlx5_core 0001:19:00.0: print_health_info:381:(pid 0):
fw_ver 14.26.226
[   13.283786] mlx5_core 0001:19:00.0: print_health_info:382:(pid 0):
hw_id 0x0000020b
[   13.283840] mlx5_core 0001:19:00.0: print_health_info:383:(pid 0):
irisc_index 2
[   13.283908] mlx5_core 0001:19:00.0: print_health_info:385:(pid 0):
synd 0x7: irisc not responding
[   13.283949] mlx5_core 0001:19:00.0: print_health_info:386:(pid 0):
ext_synd 0x00c0
[   13.284014] mlx5_core 0001:19:00.0: print_health_info:388:(pid 0):
raw fw_ver 0xe01a00e2




-- 
Alexey
