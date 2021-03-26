Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A6934A551
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhCZKLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:11:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14913 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhCZKK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:10:28 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F6Hk72vr6zkgY2;
        Fri, 26 Mar 2021 18:08:47 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.498.0; Fri, 26 Mar 2021
 18:10:23 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH -next 0/3] net: llc: Correct some function names in header
Date:   Fri, 26 Mar 2021 18:13:47 +0800
Message-ID: <20210326101350.2519614-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some make W=1 kernel build warnings in net/llc/

Yang Yingliang (3):
  net: llc: Correct some function names in header
  net: llc: Correct function name llc_sap_action_unitdata_ind() in
    header
  net: llc: Correct function name llc_pdu_set_pf_bit() in header

 net/llc/llc_c_ev.c | 4 ++--
 net/llc/llc_pdu.c  | 2 +-
 net/llc/llc_s_ac.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.25.1

