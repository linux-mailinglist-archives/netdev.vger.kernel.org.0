Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D9E1B5886
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 11:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgDWJrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 05:47:20 -0400
Received: from mail5.windriver.com ([192.103.53.11]:49084 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgDWJrT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 05:47:19 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id 03N9jQrH029481
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 23 Apr 2020 02:45:57 -0700
Received: from localhost (128.224.162.174) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 23 Apr
 2020 02:45:49 -0700
From:   Yi Zhao <yi.zhao@windriver.com>
To:     <linville@tuxdriver.com>, <netdev@vger.kernel.org>
Subject: ethtool -s always return 0 even for errors
Date:   Thu, 23 Apr 2020 17:45:47 +0800
Message-ID: <20200423094547.2066-1-yi.zhao@windriver.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [128.224.162.174]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The ethtool -s returns 0 when it fails with an error (stderr):

$ ethtool -s eth0 duplex full
Cannot advertise duplex full
$ echo $?
0
$ ethtool -s eth0 speed 10
Cannot advertise speed 10
$ echo $?
0
$ ethtool -s eth1 duplex full
Cannot get current device settings: No such device
  not setting duplex
$ echo $?
0


Is this a correct behavior of ethtool?

Thanks,
Yi


