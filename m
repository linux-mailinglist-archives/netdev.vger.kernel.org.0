Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D934B33067B
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 04:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbhCHDfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 22:35:14 -0500
Received: from m9783.mail.qiye.163.com ([220.181.97.83]:7162 "EHLO
        m9783.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbhCHDem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 22:34:42 -0500
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Mar 2021 22:34:42 EST
Received: from [192.168.188.169] (unknown [106.75.220.2])
        by m9783.mail.qiye.163.com (Hmail) with ESMTPA id 8273AC161A;
        Mon,  8 Mar 2021 11:27:05 +0800 (CST)
To:     parav@nvidia.com, saeedm@nvidia.com
Cc:     netdev@vger.kernel.org
From:   "avis.wang" <avis.wang@ucloud.cn>
Subject: mlx5 sub function issue
Message-ID: <fcf630f0-8cd7-87dd-61e2-0aee62f7465a@ucloud.cn>
Date:   Mon, 8 Mar 2021 11:27:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZQh4ZGEJCGRgYS0kYVkpNSk5KTE9LSU5NSkpVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hNSlVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NVE6Hjo*MD00AygdOhIoNEoQ
        F1ZPFChVSlVKTUpOSkxPS0lOQ0hOVTMWGhIXVRoNEghVDBoVHDsOGBcUDh9VGBVFWVdZEgtZQVlK
        S01VTE5VSUlLVUlZV1kIAVlBSkNCQjcG
X-HM-Tid: 0a780fdfc1a22085kuqy8273ac161a
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
       I have some confusion with mlx5 sub function feature. I tested it 
with Mellanox ConnectX-6 Dx recently,
then I found the maximum amount of SF in each PF is just 128, I‘m not 
sure if there is a problem with
my configuration, or there are some limits of SF in ConnectX-6.
Here is the environment:
system:                    CentOS Linux release 7.9.2009
NIC:                         Mellanox Technologies MT2892 Family 
[ConnectX-6 Dx]
firmware-version:   22.29.2002 (MT_0000000430)
kernel:                    net-next master branch 
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
mlxconfig:
PF_BAR2_ENABLE  True(1)
PF_BAR2_SIZE        8
PER_PF_NUM_SF   True(1)
PF_TOTAL_SF         65535
PF_SF_BAR_SIZE    0

When I tried to create more SF:

~# devlink port add pci/0000:b3:00.0 flavour pcisf pfnum 0 sfnum 128
devlink answers: No space left on device

Is there anything missed in configuration? Can I create more sub 
functions in ConnectX-6?

Trully yours,
avis
