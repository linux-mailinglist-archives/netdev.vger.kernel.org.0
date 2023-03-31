Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4A76D1AE9
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjCaI5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjCaI5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:57:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D3F10FA;
        Fri, 31 Mar 2023 01:57:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AC2DB82D63;
        Fri, 31 Mar 2023 08:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D770C433EF;
        Fri, 31 Mar 2023 08:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680253026;
        bh=CAT6KkoFOdkDmRKgKe2FQBByWj2FqpqeE79EKukAtJY=;
        h=From:Subject:Date:To:Cc:From;
        b=ZWnWYw7Yc7Qvn6VjyEEWYMm0mhFSfyznrFKE1LZ8R7MtPvZZaCzSid1aKSfGL6wOf
         Gd+tE0eePjhLFlhga4N1RkDHDbaY6Xr+ccKKzZo+If3vH60oC8FtpVjT/4J1szxeuA
         TFzZmyBI4DAu3RBTYoBLoNrqQZ9UayArmeZOAkqjHpNO9kAJybZylG/Bx9YlyEb8hr
         CAMEzMeRnQG/gLyQzTwKhVNZBHKjIpImKC73+eBBx89keiIVlHvLHB3G9QcYW2ku9r
         FC6uyyvAcUeBo+tLQfWQGozt7Q7G/9LGZIxFe9k8s6pSswEbKAal5wiSMo/qJTM+K9
         LCqCIy98e1j9g==
From:   Simon Horman <horms@kernel.org>
Subject: [PATCH vhost 0/3] vhost: minor kdoc fixes and MAINTAINERS update
Date:   Fri, 31 Mar 2023 10:56:54 +0200
Message-Id: <20230331-vhost-fixes-v1-0-1f046e735b9e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFagJmQC/x2LQQqDQAwAvyI5G9CNCu1XxEPU2A3IWjYqBfHvD
 R5nmLnAJKsYvIsLspxquiWHuixgipw+gjo7Q6gCVUQ1nnGzHRf9iSHR3C6BuXt1DfgxsgmOmdM
 U/UnHurr8ZnlqNz08Nwz3/QeAplrKeQAAAA==
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Eli Cohen <elic@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Parav Pandit <parav@nvidia.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this short aims to address some minor issues:

PATCH 1/3: Addresses kdoc and spelling issues in vhost.h
PATCH 2/3: Addresses kdoc in vring.h
PATCH 3/3: Adds vring.h to MAINTAINERS

There are no functional changes in this series.

---
Simon Horman (3):
      vdpa: address kdoc warnings
      vringh: address kdoc warnings
      MAINTAINERS: add vringh.h to Virtio Core and Net Drivers

 MAINTAINERS            |  1 +
 include/linux/vdpa.h   | 14 +++++++++++---
 include/linux/vringh.h | 17 +++++++++++++++--
 3 files changed, 27 insertions(+), 5 deletions(-)

base-commit: da617cd8d90608582eb8d0b58026f31f1a9bfb1d

