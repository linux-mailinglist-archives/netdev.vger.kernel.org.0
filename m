Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7B72FA912
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390719AbhARSmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:42:02 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:34735 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393682AbhARS1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 13:27:43 -0500
Received: from localhost (junagarh.blr.asicdesigners.com [10.193.185.238])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 10IIQaJg005570;
        Mon, 18 Jan 2021 10:26:37 -0800
Date:   Mon, 18 Jan 2021 23:56:37 +0530
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     hch@lst.de, rahul.lakkireddy@chelsio.com, rajur@chelsio.com
Subject: how to determine if buffers are in user-space/kernel-space
Message-ID: <20210118182636.GB15369@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We have an out-of-tree kernel module which was using
segment_eq(get_fs(), KERNEL_DS) to determine whether buffers are in
Kernel space vs User space. However, with the get_fs() and its friends
removed[1], we are out of ideas on how to determine if buffers are in
user space or kernel space. Can someone shed some light on how to
accomplish it?


Thanks in Advance,
Raju

[1]
https://patchwork.kernel.org/project/linux-fsdevel/patch/20200817073212.830069-10-hch@lst.de/
