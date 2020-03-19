Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81B8218B18D
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 11:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgCSKej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 06:34:39 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:36744 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbgCSKej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 06:34:39 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jEsVa-000400-4g; Thu, 19 Mar 2020 11:34:38 +0100
Date:   Thu, 19 Mar 2020 11:34:38 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Bug URGENT Report with new kernel 5.5.10-5.6-rc6
Message-ID: <20200319103438.GO979@breakpoint.cc>
References: <CALidq=XsQy66n-pTMOMN=B7nEsk7BpRZnUHery5RJyjnMsiXZQ@mail.gmail.com>
 <CALidq=VVpixeJFJFkUSeDqTW=OX0+dhA04ypE=y949B+Aqaq0w@mail.gmail.com>
 <CALidq=UXHz+rjiG5JxAz-CJ1mKsFLVupsH3W+z58L2nSPKE-7w@mail.gmail.com>
 <20200319003823.3b709ad8@elisabeth>
 <CALidq=Xow0EkAP4LkqvQiDOmVDduEwLKa4c-A54or3GMj6+qVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALidq=Xow0EkAP4LkqvQiDOmVDduEwLKa4c-A54or3GMj6+qVw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Zaharinov <micron10@gmail.com> wrote:

[ trimming CC ]

Please revert

commit 28f8bfd1ac948403ebd5c8070ae1e25421560059
netfilter: Support iif matches in POSTROUTING

