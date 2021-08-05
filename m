Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0A03E1D69
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 22:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241095AbhHEUjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 16:39:33 -0400
Received: from gecko.sbs.de ([194.138.37.40]:52145 "EHLO gecko.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241038AbhHEUjb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 16:39:31 -0400
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by gecko.sbs.de (8.15.2/8.15.2) with ESMTPS id 175Kd4IU003303
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Aug 2021 22:39:04 +0200
Received: from [139.22.32.15] ([139.22.32.15])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 175Kd3qS026651;
        Thu, 5 Aug 2021 22:39:03 +0200
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        linuxwwan@intel.com
From:   Jan Kiszka <jan.kiszka@siemens.com>
Subject: wwan/iosm vs. xmm7360
Message-ID: <0545a78f-63f0-f8dd-abdb-1887c65e1c79@siemens.com>
Date:   Thu, 5 Aug 2021 22:39:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chetan,

at the risk of having missed this being answered already:

How close is the older xmm7360 to the now supported xmm7560 in mainline?

There is that reverse engineered PCI driver [1] with non-standard
userland interface, and it would obviously be great to benefit from
common infrastructure and specifically the modem-manager compatible
interface. Is this realistic to achieve for the 7360, or is that
hardware or its firmware too different?

Thanks,
Jan

[1] https://github.com/xmm7360/xmm7360-pci

-- 
Siemens AG, T RDA IOT
Corporate Competence Center Embedded Linux
