Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 535AFB05DA
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 01:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbfIKXJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 19:09:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50050 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbfIKXJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 19:09:01 -0400
Received: from localhost (unknown [88.214.186.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 43FF1154F89D8;
        Wed, 11 Sep 2019 16:09:00 -0700 (PDT)
Date:   Thu, 12 Sep 2019 01:08:58 +0200 (CEST)
Message-Id: <20190912.010858.595983476998842948.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net 0/2][pull request] Intel Wired LAN Driver Updates
 2019-09-11
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190911164955.10644-1-jeffrey.t.kirsher@intel.com>
References: <20190911164955.10644-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 16:09:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed, 11 Sep 2019 09:49:53 -0700

> This series contains fixes to ixgbe.
> 
> Alex fixes up the adaptive ITR scheme for ixgbe which could result in a
> value that was either 0 or something less than 10 which was causing
> issues with hardware features, like RSC, that do not function well with
> ITR values that low.
> 
> Ilya Maximets fixes the ixgbe driver to limit the number of transmit
> descriptors to clean by the number of transmit descriptors used in the
> transmit ring, so that the driver does not try to "double" clean the
> same descriptors. 

Pulled, thanks Jeff.
