Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 476385DFF4
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 10:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfGCIgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 04:36:03 -0400
Received: from mail5.windriver.com ([192.103.53.11]:53892 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727019AbfGCIgD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 04:36:03 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x638YviP006832
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Wed, 3 Jul 2019 01:35:29 -0700
Received: from [128.224.162.143] (128.224.162.143) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server id 14.3.439.0; Wed, 3 Jul 2019
 01:35:21 -0700
To:     <edumazet@google.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
From:   ZhangXiao <xiao.zhang@windriver.com>
Subject: Shall we add some note info for tcp_min_snd_mss?
Message-ID: <5D1C68C8.6020408@windriver.com>
Date:   Wed, 3 Jul 2019 16:35:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David & Eric,

Commit 5f3e2bf0 (tcp: add tcp_min_snd_mss sysctl) add a new interface to
adjust network. While if this variable been set too large, for example
larger then (MTU - 40), the net link maybe damaged. So, how about adding
some warning messages for the operator/administrator? In document, or in
source code.

Thanks
Xiao
