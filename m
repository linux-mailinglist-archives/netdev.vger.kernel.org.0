Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86FEE196A23
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 01:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgC2ABi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 20:01:38 -0400
Received: from smtp52.iq.pl ([86.111.240.252]:50535 "EHLO smtp52.iq.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgC2ABi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 20:01:38 -0400
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Mar 2020 20:01:37 EDT
Received: from [192.168.2.111] (unknown [185.78.72.18])
        (Authenticated sender: pstaszewski@itcare.pl)
        by smtp.iq.pl (Postfix) with ESMTPSA id 48qbCn6hPfz41NJ
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 00:53:57 +0100 (CET)
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
From:   =?UTF-8?Q?Pawe=c5=82_Staszewski?= <pstaszewski@itcare.pl>
Subject: Latest net-next from today and mellanox driver compier error
Message-ID: <e7b0e756-80f9-5f3e-86b0-f8c016c755a2@itcare.pl>
Date:   Sun, 29 Mar 2020 00:52:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi


Latest net-next kernel :

drivers/net/ethernet/mellanox/mlx4/crdump.c:45:10: error: initializer 
element is not constant
   .name = region_cr_space_str,
           ^~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx4/crdump.c:45:10: note: (near 
initialization for 'region_cr_space_ops.name')
drivers/net/ethernet/mellanox/mlx4/crdump.c:50:10: error: initializer 
element is not constant
   .name = region_fw_health_str,
           ^~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx4/crdump.c:50:10: note: (near 
initialization for 'region_fw_health_ops.name')
   CC      drivers/net/ethernet/mellanox/mlx5/core/en_arfs.o
   AR      drivers/nvmem/built-in.a
make[5]: *** [scripts/Makefile.build:268: 
drivers/net/ethernet/mellanox/mlx4/crdump.o] Error 1
make[5]: *** Waiting for unfinished jobs....


