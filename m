Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC16831DD19
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 17:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhBQQP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 11:15:27 -0500
Received: from s-terra.s-terra.com ([193.164.201.59]:53415 "EHLO
        s-terra.s-terra.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234078AbhBQQPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 11:15:08 -0500
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Feb 2021 11:15:08 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s-terra.ru; s=mail;
        t=1613577993; bh=z1ZJy5btvrX6ccMWHhdu/ImCYptIQksKbzrdqLQRx64=;
        h=To:From:Subject:Date:From;
        b=l9AsYuhbo57ZKWxSoglLqZNcuz2iUv+2HSKCymDcMCzde/5l9/mt1kDDX2EjBp10u
         if4hX4hTK5F7+yQoxpIjTmJNM8TH1zHWPFoaSgS4ZZZ+YbyrIhMP3D/7I4CyBgZJvw
         cCP3GhP8j5gE0m9JdNqzUZyhX3QI+DDirCLvfCPk=
To:     <netdev@vger.kernel.org>
From:   =?UTF-8?B?0JzRg9GA0LDQstGM0LXQsiDQkNC70LXQutGB0LDQvdC00YA=?= 
        <amuravyev@s-terra.ru>
Subject: null terminating of IFLA_INFO_KIND/IFLA_IFNAME
Message-ID: <baea7ed0-ba32-3cc0-3885-7b77a72cb409@s-terra.ru>
Date:   Wed, 17 Feb 2021 19:06:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: EMX.sterracsp.s-terra.com
 (fdff:1ea7:9484:0:b0e5:b137:3bee:6c45) To EMX.sterracsp.s-terra.com
 (fdff:1ea7:9484:0:b0e5:b137:3bee:6c45)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

A noob question that I haven't found an answer.

Just wanted to clarify a piece of iproute2 code.

ip/iplink.c:

> 1058         addattr_l(&req.n, sizeof(req), IFLA_INFO_KIND, type,
> 1059              strlen(type));

also ip/iplink.c:

> 1115         addattr_l(&req.n, sizeof(req),
> 1116               !check_ifname(name) ? IFLA_IFNAME : IFLA_ALT_IFNAME,
> 1117               name, strlen(name) + 1);
My question is why we skip terminating null character for IFLA_INFO_KIND 
(the first case) and don't skip it for IFLA_IFNAME (the second case)? I 
mean "strlen(type)" and "strlen(name) + 1".

-- 
Best regards,
Alexander Muravev

