Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2FB30FDBA
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239833AbhBDUF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:05:56 -0500
Received: from mga17.intel.com ([192.55.52.151]:33377 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238886AbhBDUFf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 15:05:35 -0500
IronPort-SDR: jvAFo7DsuFfZATPYGQi5hzoh0imAhOD9PBxPJLG6JDEIc0fV2QZupf54Iyc+hvxUnnXTqouC4Z
 NCPzAhHCb9wA==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="161075999"
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="161075999"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 12:04:55 -0800
IronPort-SDR: w25dlOuI26uqy8gsBnyLijkH7cRf4RJUGufCR72zFj2raTNoWynOFcePAKHrki6yHcm97DFzex
 eFpyZgruJOhQ==
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="434093065"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.188.246])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 12:04:55 -0800
Date:   Thu, 4 Feb 2021 12:04:54 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <jerinj@marvell.com>,
        <lcherian@marvell.com>
Subject: Re: [net-next v3 00/14] Add Marvell CN10K support
Message-ID: <20210204120454.000054d6@intel.com>
In-Reply-To: <1612437872-51671-1-git-send-email-gakula@marvell.com>
References: <1612437872-51671-1-git-send-email-gakula@marvell.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geetha sowjanya wrote:

> v2-v3
> Reposting as a single thread.

FYI, it didn't work, suggest you try adding the git-send-email option
(via git-config)

sendemail.thread=true
sendemail.chainreplyto=false

And you can test locally by using first using git send-email to export
to mbox and checking for References and In-Reply-to headers. Then
sending for real.

Good luck!
