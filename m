Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7062B316A
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 00:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgKNXf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 18:35:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgKNXf0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 18:35:26 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A563224137;
        Sat, 14 Nov 2020 23:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605396926;
        bh=UTD2Bh9fb2HrkUiL49sMKAYceM4iQg2Jifv+pJ8UiNc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uEhpiu1If5hEFVoPGew8BartDhIkNgba+Nkv0Cf4nng/FStVxMoBXzJDXWtgfIXU5
         coDxNCnBdzFaYX14+2Kq71IMTU4YllY8NKqvqhMYTY5Y3gbCoFwkMqPgMi7hhaVxvf
         Kd+Z5VKtbQdepuVooE0JuWyDJlCWH5M+mvDYyolg=
Date:   Sat, 14 Nov 2020 15:35:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com, pradeep@us.ibm.com,
        drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        ricklind@linux.ibm.com
Subject: Re: [PATCH net-next 01/12] ibmvnic: Ensure that subCRQ entry reads
 are ordered
Message-ID: <20201114153524.1a32241f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605208207-1896-2-git-send-email-tlfalcon@linux.ibm.com>
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
        <1605208207-1896-2-git-send-email-tlfalcon@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 13:09:56 -0600 Thomas Falcon wrote:
> Ensure that received Subordinate Command-Response Queue
> entries are properly read in order by the driver.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Are you sure this is not a bug fix?
