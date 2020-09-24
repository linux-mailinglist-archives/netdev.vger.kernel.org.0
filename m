Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CED27700A
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 13:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbgIXLg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 07:36:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:38472 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbgIXLg3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 07:36:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600947387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MZyvBg20qT73QpwIVlDigtRjVhnHdUuTkqO7GvwSeIE=;
        b=e6W4eeYUCdmzKdxQ7xtoWbgJ9qdgvwr2lNlDirzA5K8Wrebqf2M3M/HUEs+GFMz86GkDnO
        +SYxT7FpIuIZB1snPQ5GEuM7p9YxWimxBNYh3XwHLw5J+Y/O8gOgEZTtlGoi1WAQufifHL
        TGzb/bqFAm2cN/kjrzhCyCG1l4fajns=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7D634AC65;
        Thu, 24 Sep 2020 11:36:27 +0000 (UTC)
Message-ID: <7f9e20b2eab783303c4e5f5c3244366fa88a6567.camel@suse.com>
Subject: Re: [PATCH 3/4] net: usb: rtl8150: use usb_control_msg_recv() and
 usb_control_msg_send()
From:   Oliver Neukum <oneukum@suse.com>
To:     Himadri Pandya <himadrispandya@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        pankaj.laxminarayan.bharadiya@intel.com,
        Kees Cook <keescook@chromium.org>, yuehaibing@huawei.com,
        petkan@nucleusys.com, ogiannou@gmail.com,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Greg KH <gregkh@linuxfoundation.org>
Date:   Thu, 24 Sep 2020 13:13:56 +0200
In-Reply-To: <CAOY-YVkciMUgtS7USbBh_Uy_=fVWwMMDeHv=Ub_H3GaY0FKZyQ@mail.gmail.com>
References: <20200923090519.361-1-himadrispandya@gmail.com>
         <20200923090519.361-4-himadrispandya@gmail.com>
         <1600856557.26851.6.camel@suse.com>
         <CAOY-YVkHycXqem_Xr6nQLgKEunk3MNc7dBtZ=5Aym4Y06vs9xQ@mail.gmail.com>
         <1600870858.25088.1.camel@suse.com>
         <CAOY-YVkciMUgtS7USbBh_Uy_=fVWwMMDeHv=Ub_H3GaY0FKZyQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Mittwoch, den 23.09.2020, 20:02 +0530 schrieb Himadri Pandya:

> I meant that it was stupid to change it without properly understanding
> the significance of GFP_NOIO in this context.
> 
> So now, do we re-write the wrapper functions with flag passed as a parameter?

Hi,

I hope I set you in CC for a patch set doing exactly that.

Do not let me or other maintainers discourage you from writing patches.
Look at it this way. Had you not written this patch, I would not have
looked into the matter. Patches are supposed to be reviewed.
If you want additional information, just ask. We do not want
people discouraged from writing substantial patches.

	Regards
		Oliver


