Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A722656AC
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 03:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725306AbgIKBcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 21:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgIKBcb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 21:32:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0C76208FE;
        Fri, 11 Sep 2020 01:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599787950;
        bh=bi2meK06h6TW0z77cfKCBUPeYd+LBdmhoyQPyxrqCEY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FjvredNb7AILxB7redT66htIVI71Qge45edfdkvO+L8HDlmB8xDpJL7YntWkq/0/a
         ySSozhE4l/qfn/tlvqi6a7HT6yP6iEsjJqZmbEnPu9ZjedmJH0oGiyAPneY0ChZcKX
         vhGVaHqDBoxGRagjoyoomr0g7OfPgMT4sb7xuDtk=
Date:   Thu, 10 Sep 2020 18:32:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [net-next v5 3/5] devlink: introduce flash update overwrite
 mask
Message-ID: <20200910183229.72b808f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910212812.2242377-4-jacob.e.keller@intel.com>
References: <20200910212812.2242377-1-jacob.e.keller@intel.com>
        <20200910212812.2242377-4-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 14:28:10 -0700 Jacob Keller wrote:
> +#define DEVLINK_FLASH_OVERWRITE_SETTINGS BIT(DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT)
> +#define DEVLINK_FLASH_OVERWRITE_IDENTIFIERS BIT(DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT)

You got two more here.
