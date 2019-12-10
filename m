Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A9B117F4C
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 06:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfLJFEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 00:04:09 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:1634 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfLJFEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 00:04:09 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id EE90D4176E
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 13:04:03 +0800 (CST)
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
From:   wenxu <wenxu@ucloud.cn>
Subject: net-next tree mlx5e set sriov_numf failed
Message-ID: <df826cdd-f2cf-b7da-f24a-cec9d463a600@ucloud.cn>
Date:   Tue, 10 Dec 2019 13:04:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSFVNTEhCQkJMQ01ITE1CTllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PTY6IRw*MDg5TEkdSS4uSDU3
        ISkaFDdVSlVKTkxOQk5PSU9PS0xPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSkxOTTcG
X-HM-Tid: 0a6eee3161b42086kuqyee90d4176e
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi mellanox team,

I test the net-next branch, set the sriov_numvf fail for

Cannot allocate memory


# uname -r
5.5.0-rc1+

# ethtool -i eth0
driver: mlx5_core
version: 5.0-0
firmware-version: 16.25.1020 (MT_0000000080)
expansion-rom-version:
bus-info: 0000:81:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: yes

# echo 1 > /sys/class/net/eth0/device/sriov_numvfs
-bash: echo: write error: Cannot allocate memory

dmesg show:
[Tue Dec 10 12:24:26 2019] mlx5_core 0000:81:00.0: E-Switch: Enable: mode(LEGACY), nvfs(1), active vports(2)
[Tue Dec 10 12:24:26 2019] mlx5_core 0000:81:00.0: not enough MMIO resources for SR-IOV
[Tue Dec 10 12:24:26 2019] mlx5_core 0000:81:00.0: mlx5_sriov_enable:149:(pid 20601): pci_enable_sriov failed : -12
[Tue Dec 10 12:24:26 2019] mlx5_core 0000:81:00.0: E-Switch: Disable: mode(LEGACY), nvfs(1), active vports(2)


BR

wenxu




