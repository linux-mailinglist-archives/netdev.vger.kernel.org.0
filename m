Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393EF1BCD2E
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 22:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgD1UNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 16:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:32912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbgD1UNN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 16:13:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74473206D9;
        Tue, 28 Apr 2020 20:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588104793;
        bh=vpAbU3pDSFySCzimpo7rQmvVf3wj7LGg8YUN54MunG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cl8OlgNbc44llGzbdiQx6Um4ESG79Yn1rKz7mNhK6Yu5+KkKjeCyKLRm9adNCUmTJ
         fSCRywDYF6mO1/hrmBqNrhjA6tg3oHDq+FizRjUCPr3BrIUX+O57hSMJde1IXrH1zb
         +iuBvEw32mfKxp73DLpyrEPdxAD5WN4wRa7CQIKI=
Date:   Tue, 28 Apr 2020 13:13:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [iproute2 v2] devlink: add support for DEVLINK_CMD_REGION_NEW
Message-ID: <20200428131311.18fd742f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200428172057.1109672-1-jacob.e.keller@intel.com>
References: <20200428172057.1109672-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Apr 2020 10:20:57 -0700 Jacob Keller wrote:
> +	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_REGION_NEW,
> +			NLM_F_REQUEST | NLM_F_ACK);

misaligned
