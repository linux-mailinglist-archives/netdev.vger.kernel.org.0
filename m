Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFC231FECC
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 19:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhBSS32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 13:29:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:47018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhBSS30 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 13:29:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAD0264DA8;
        Fri, 19 Feb 2021 18:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613759326;
        bh=kp5plKBOewCK12rmpAp8zDCTtI6fbfhCRCrstcJ+rHQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cMjUYaFOp9BNBam+hNuz5sW2d68vFr31ZqeDHtqII6N5UaTqxsLAlAi1GC76GPry/
         40TSwtkaGwK5F2ltqpzTcQcuChXbG3RIQuY1XJJ4CRPq8cGo/vnsTMLaEXuqKptsyI
         uvgfv2MRxlYSqqZrlsEIKTN4Hhprg6ROWRNG4wQu99aEXW03kHX6D+nCN6y7qNtMZU
         DDin4U1yehiFFXn/niIvoF82C89Znlh98h58DX9BjP6NAskB6srSE4WmB1PByXvuOt
         qxCtESZUkz8dgo5bFG/AzsXiceeEfUAP3vzIhHWn0QEQ4ZlaU2GIegynyzCfDeoQ0r
         CKtP3Bt2pZTcw==
Date:   Fri, 19 Feb 2021 10:28:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Christina Jacob <cjacob@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Prakash Brahmajyosyula <bprakash@marvell.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] octeontx2-af: Fix an off by one in
 rvu_dbg_qsize_write()
Message-ID: <20210219102844.1ecf1d25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YC+LUJ0YhF1Yutaw@mwanda>
References: <YC+LUJ0YhF1Yutaw@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Feb 2021 12:56:32 +0300 Dan Carpenter wrote:
> This code does not allocate enough memory for the NUL terminator so it
> ends up putting it one character beyond the end of the buffer.
> 
> Fixes: 8756828a8148 ("octeontx2-af: Add NPA aura and pool contexts to debugfs")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Fix looks correct, thanks! The interface itself is another matter..
