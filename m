Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0135914F1D5
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgAaSHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:07:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgAaSHm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:07:42 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A98C20663;
        Fri, 31 Jan 2020 18:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580494061;
        bh=KlZGij+CnOwy+aU51p/mOITjXZTLyaQ3nseMKNAxiGU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bQFY7CCl8F/D7JLAFFKwo5ZrCKoCMUIEqzlXkrbAC3iXkCaTjg7zu1rm4xp5e/rKa
         1GZk7ybDyRKf4AMoxY53e2vb8RhPi6xO+ID+Qau0C9L3J1En/Rm7PLD8SO3TM633Un
         AvBed6uLNkNeDZ0OcgYzEDsHeltIeDhRaE0Cc1JM=
Date:   Fri, 31 Jan 2020 10:07:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
Subject: Re: [PATCH 15/15] ice: add ice.rst devlink documentation file
Message-ID: <20200131100740.0b04d7a9@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200130225913.1671982-16-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
        <20200130225913.1671982-16-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jan 2020 14:59:10 -0800, Jacob Keller wrote:
> Now that the ice driver has gained some devlink support, add
> a driver-specific documentation file for it.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

This should have been when info items are added.
