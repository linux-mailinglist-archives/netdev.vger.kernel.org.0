Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0504D3685E
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 01:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfFEXxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 19:53:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42474 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfFEXxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 19:53:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1E78143B8003;
        Wed,  5 Jun 2019 16:53:44 -0700 (PDT)
Date:   Wed, 05 Jun 2019 16:53:44 -0700 (PDT)
Message-Id: <20190605.165344.1148251680371473480.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     lihong.yang@intel.com, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, andrewx.bowers@intel.com
Subject: Re: [net-next 1/2] i40e: Do not check VF state in
 i40e_ndo_get_vf_config
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190605194516.10125-1-jeffrey.t.kirsher@intel.com>
References: <20190605194516.10125-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 16:53:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed,  5 Jun 2019 12:45:15 -0700

> From: Lihong Yang <lihong.yang@intel.com>
> 
> The VF configuration returned in i40e_ndo_get_vf_config is
> already stored by the PF. There is no dependency on any
> specific state of the VF to return the configuration.
> Drop the check against I40E_VF_STATE_INIT since it is not
> needed.
> 
> Signed-off-by: Lihong Yang <lihong.yang@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied.
