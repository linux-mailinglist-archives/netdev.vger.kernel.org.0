Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502413213EC
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 11:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhBVKPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 05:15:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:36274 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230481AbhBVKPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 05:15:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613988896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ELXzRz8wqxmWh7nxQ8sY/Rc503gVPWkSVVbdra6CB2U=;
        b=ss26i5QG4vdiWIR0OvwE9mvUvb11nRCQMtDUTNJsXb75LX3EQeP+wW4yq3EUF5MrPaCfwt
        eXlcyFcFQON90MaTCq2ZclaQvysYX8Lt7InqtlCHmcQjr89cB6ZAN09HHvRlEPJgKulEef
        becgDtDB2OBF7ckojUTj+k68xTLLcSc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 81FF8AC6F;
        Mon, 22 Feb 2021 10:14:56 +0000 (UTC)
Message-ID: <8cd8ba7cfd3d2db647c48224063122fb865574bb.camel@suse.com>
Subject: Re: [PATCHv3 3/3] CDC-NCM: record speed in status method
From:   Oliver Neukum <oneukum@suse.com>
To:     Grant Grundler <grundler@chromium.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        davem@davemloft.org, Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Date:   Mon, 22 Feb 2021 11:14:52 +0100
In-Reply-To: <CANEJEGvsYPmnxx2sV89aLPJzK_SgWEW8FPhgo2zNk2d5zijK2Q@mail.gmail.com>
References: <20210218102038.2996-1-oneukum@suse.com>
         <20210218102038.2996-4-oneukum@suse.com>
         <CANEJEGvsYPmnxx2sV89aLPJzK_SgWEW8FPhgo2zNk2d5zijK2Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Freitag, den 19.02.2021, 07:30 +0000 schrieb Grant Grundler:
> On Thu, Feb 18, 2021 at 10:21 AM Oliver Neukum <oneukum@suse.com> wrote:

Hi,

> Since this patch is missing the hunks that landed in the previous
> patch and needs a v4, I'll offer my version of the commit message in

That is bad. I will have to search for that.

> case you like it better:

Something written by a native speaker with knowledge in the field is
always better. I will take it, wait two weeks and then resubmit.

	Regards
		Oliver


