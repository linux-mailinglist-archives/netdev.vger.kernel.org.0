Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 815CB14F92F
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 18:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgBARnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 12:43:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbgBARnD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 12:43:03 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB2C320679;
        Sat,  1 Feb 2020 17:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580578983;
        bh=D5Rz1mPiNxS+s8ZaNHYo+O//yp8a2xrbnTeomH6pYuE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bxvyAv1QsyQZcm22qQDA6nwN6iVCd4tkuiJUvu42MfX9GinGJLeiaolEMqlQcweFP
         uGB46qJvrWNAQ/jly2D930ogQ1FmUufoCw0hGFoNxTMxmB5ur1CBWGL7OO33OPaSoe
         afTSbhrextyKLWVV7ykD41bvudlMhrvQZu4NgoxA=
Date:   Sat, 1 Feb 2020 09:43:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
Subject: Re: [PATCH 08/15] devlink: add devres managed devlinkm_alloc and
 devlinkm_free
Message-ID: <20200201094302.7b6ed97a@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <78e85b70-41f3-d2fa-1227-dea732dea116@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
        <20200130225913.1671982-9-jacob.e.keller@intel.com>
        <20200131100723.0d6893fa@cakuba.hsd1.ca.comcast.net>
        <78e85b70-41f3-d2fa-1227-dea732dea116@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 16:51:10 -0800, Jacob Keller wrote:
> TL;DR; Yes, I'd like to have a single devlink for the device, but no, I
> don't have a good answer for how to do it sanely.

Ack, it not a new problem and I don't have a solution either :(

I don't think mlx5 has this distinction of only single/first PF being
able to perform device-wide updates so perhaps it's better to not
introduce that notion? 
