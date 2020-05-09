Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865021CBDDB
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 07:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgEIFsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 01:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgEIFsK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 01:48:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ECEB21582;
        Sat,  9 May 2020 05:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589003289;
        bh=pX0brJrCinBMhLMXpPgL2P+Mk4EgjHav7YI4qeZCWMc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fMWWt/fMwr6G3LabAxiA38lVoe6gPbg9+ETyPjtQHVOabCegIZSD/uAYNl1a4boYx
         1PpNqeHjRirvFBG25HY0UGvuDYhqvPjwuNe4XLv/t2zTTUCozagXaFlalf/f+98Qj9
         fr+6JtWdjlDhtrzX4hYD/ombrTMxlkEXdIHqVzcs=
Date:   Fri, 8 May 2020 22:48:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/atheros: remove redundant assignment to variable
 size
Message-ID: <20200508224807.5797e7b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508223321.483485-1-colin.king@canonical.com>
References: <20200508223321.483485-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 May 2020 23:33:21 +0100 Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable size is being assigned with a value that is never read,
> the assignment is redundant and cab be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thank you!
