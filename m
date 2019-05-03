Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D882B127F3
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 08:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfECGqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 02:46:21 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:54680 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbfECGqV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 02:46:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 611F920255;
        Fri,  3 May 2019 08:46:19 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NoD8G8el5xWt; Fri,  3 May 2019 08:46:19 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 03EB82007A;
        Fri,  3 May 2019 08:46:19 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 3 May 2019
 08:46:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 8F50D31805BF;
 Fri,  3 May 2019 08:46:18 +0200 (CEST)
Date:   Fri, 3 May 2019 08:46:18 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Vakul Garg <vakul.garg@nxp.com>
CC:     Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC HACK] xfrm: make state refcounting percpu
Message-ID: <20190503064618.GM17989@gauss3.secunet.de>
References: <20190423162521.sn4lfd5iia566f44@breakpoint.cc>
 <20190424104023.10366-1-fw@strlen.de>
 <20190503060748.GK17989@gauss3.secunet.de>
 <VE1PR04MB6670F77D42F9DA342F8E58238B350@VE1PR04MB6670.eurprd04.prod.outlook.com>
 <20190503062206.GL17989@gauss3.secunet.de>
 <VE1PR04MB66701E2D8CE661F280D6A6C48B350@VE1PR04MB6670.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <VE1PR04MB66701E2D8CE661F280D6A6C48B350@VE1PR04MB6670.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 61564AA0-4B17-416D-B95E-12A74195A4FC
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 03, 2019 at 06:34:29AM +0000, Vakul Garg wrote:
> > -----Original Message-----
> > From: Steffen Klassert <steffen.klassert@secunet.com>
> > 
> > Also, is this a new problem or was it always like that?
> 
> It is always like this. On 4-core, 8-core platforms as well, these atomics consume significant cpu 
> (8 core cpu usage is more than 4 core).

Ok, so it is not a regression. That's what I wanted to know.

Did the patch from Florian improve the situation?

