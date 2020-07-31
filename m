Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A972340DF
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 10:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731925AbgGaIJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 04:09:29 -0400
Received: from mail-proxy25223.qiye.163.com ([103.129.252.23]:25479 "EHLO
        mail-proxy25223.qiye.163.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731607AbgGaIJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 04:09:29 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 2EE4E41D53;
        Fri, 31 Jul 2020 16:09:27 +0800 (CST)
To:     Saeed Mahameed <saeedm@mellanox.com>
From:   wenxu <wenxu@ucloud.cn>
Subject: Ktls offload in cx6 of mellanox
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Message-ID: <616cd09a-c0ba-68e1-5d72-96b0f9abd2e4@ucloud.cn>
Date:   Fri, 31 Jul 2020 16:09:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZSh4ZHkIdQxlCHR5LVkpOQk1KQ0lCTUxITEhVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS09ISFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MTI6AQw4Pz5NTjYLKAIVCDEf
        URcaCzlVSlVKTkJNSkNJQk1MTktJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFKT0pLNwY+
X-HM-Tid: 0a73a3eb33d82086kuqy2ee4e41d53
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi mellanox team,


I test the ktls offload feature with CX6 dx with net-next tree.


fw version is the latest 22.28.1002

# ethtool -i net3
driver: mlx5_core
version: 5.0-0
firmware-version: 22.28.1002 (MT_0000000430)
expansion-rom-version:
bus-info: 0000:07:00.1
supports-statistics: yes
supports-test: yes
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: yes

# ethtool -K net3 |  grep tls-hw

tls-hw-tx-offload: on
tls-hw-rx-offload: off [fixed]


I found the rx offload is not supported currently?


BR

wenxu

