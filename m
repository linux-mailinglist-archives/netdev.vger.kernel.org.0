Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 135FDCC99D
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 13:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbfJEL1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 07:27:43 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:39925 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbfJEL1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 07:27:43 -0400
Received: by mail-ed1-f44.google.com with SMTP id a15so8281242edt.6
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 04:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=dbbFzFbuYXFMklSehmYBYG0x3kGiIqCFoN5zFUGHdbc=;
        b=eGiBaKFgnxiBHXXbWrvdiEz8/N7wBwD9z8DZEyfjzdcSBLW6ZtwtMtcRfc9Inn2Fu3
         VKfiOxaj4G+ZhfkLLS8amX6YGpgw8DKKMmbuUlCMN9PKOAGHrvkBHjFaDRBua4EC0Fmi
         9iuagXSthViRzBOJqPY6SnuzGoOjgHSwUwThJCGm1ur8n/7ZmftY5DitwwTVP/4dhce0
         foE4BfWxk3QCxHehvY8h2EePNfMecnv/yCBW85cxtdeJk64BEs8o5Nix4Lqp2/ScBuz6
         7Yq1GkWHwk6aW6mh9paYv/AWvrhNFcFgzlEaUmODWuKGpn1KkXW0f7phLHgbgdzUylW6
         ickQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=dbbFzFbuYXFMklSehmYBYG0x3kGiIqCFoN5zFUGHdbc=;
        b=ObMmsNCRMslStHnubKiMTxlYZsYPod19jQi/UJN7+zhfylRJQucshbFkt7RpfhGW33
         PrLizCsWiEMc8+OD9iKP4+1hpLicsFQAdxfS2Gpu/elLtpLVMzm4kOdaob6EtJYQVAkB
         gXt/U0b16DUDQF59n8QqSJTRCVmdYcFnsWGzPvVuLGHxFZh9Wr/NvRONfovp7Sb4F0f7
         KItty+KTMuv+hUwNrZtcyf11xOY8gVRrYbYLwD4GtWnDJmUYKZ+a/JgmAOfdzWOyJvht
         61GFjBQ/lMGajMaEPiZSKN1jk1xlj59P9e+kAlf2PsBYpIU8t0EAmknC7yWWHoi/+YoB
         nAhA==
X-Gm-Message-State: APjAAAUGzFqc1PlAlL1+gQxz18WF0qXwCFGLW7XfaDFmnsqzRwweERl9
        aOtbKf6L87R1pcwc9qN2txRPl3595BoobQ==
X-Google-Smtp-Source: APXvYqyRnF7nd0LNhhIXuvcqKh6epCrXAVpc0UlpY27YRrYWUL8FB50FG2WodQ5p0nqMgmDHRntoRQ==
X-Received: by 2002:a50:b0c5:: with SMTP id j63mr20193781edd.90.1570274860814;
        Sat, 05 Oct 2019 04:27:40 -0700 (PDT)
Received: from [192.168.1.2] (host-109-89-151-97.dynamic.voo.be. [109.89.151.97])
        by smtp.gmail.com with ESMTPSA id a18sm1010679ejy.88.2019.10.05.04.27.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Oct 2019 04:27:40 -0700 (PDT)
To:     netdev@vger.kernel.org
From:   =?UTF-8?Q?Fran=c3=a7ois_Valenduc?= <francoisvalenduc@gmail.com>
Subject: RTL8723de support
Message-ID: <beb6c2d5-43fa-7dbb-17a0-a15bc98de690@gmail.com>
Date:   Sat, 5 Oct 2019 13:27:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: fr-moderne
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everybody,

I am thinking of buying a new laptop which has a Realtek 8723DE wifi
adapter. I found this driver which is apparently now included in the
main kernel: https://github.com/lwfinger/rtlwifi_new
The instruction there says to load the rtl8723de driver, which seems not
to exist anymore. The rtl8723de folder is also almost empty. Can
somebody clarify this ? Does the rtr8723be now also support the
rtl8723de card ?

Thanks in advance for your help,
Best regards.

François Valenduc
