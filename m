Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFB33685F
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 01:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfFEXxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 19:53:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42480 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfFEXxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 19:53:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2957F143B8003;
        Wed,  5 Jun 2019 16:53:51 -0700 (PDT)
Date:   Wed, 05 Jun 2019 16:53:50 -0700 (PDT)
Message-Id: <20190605.165350.2288911528761294407.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     lihong.yang@intel.com, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next 2/2] i40e: Check and set the PF driver state first
 in i40e_ndo_set_vf_mac
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190605194516.10125-2-jeffrey.t.kirsher@intel.com>
References: <20190605194516.10125-1-jeffrey.t.kirsher@intel.com>
        <20190605194516.10125-2-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 16:53:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed,  5 Jun 2019 12:45:16 -0700

> From: Lihong Yang <lihong.yang@intel.com>
> 
> The PF driver state flag __I40E_VIRTCHNL_OP_PENDING needs to be
> checked and set at the beginning of i40e_ndo_set_vf_mac. Otherwise,
> if there are error conditions before it, the flag will be cleared
> unexpectedly by this function to cause potential race conditions.
> Hence move the check to the top of this function.
> 
> Signed-off-by: Lihong Yang <lihong.yang@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied.
