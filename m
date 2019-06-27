Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1FAD57ADB
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 06:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfF0EzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 00:55:16 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:37112 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfF0EzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 00:55:15 -0400
Received: by mail-wr1-f41.google.com with SMTP id v14so843185wrr.4
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 21:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jVv8AqSegnxp0gWnatsiyEbG1UXPWGptzgD/iRThcH0=;
        b=Fs9A3i5pf/domm/RKWLDIuzKOPKQYhwF2HNHkysJPOpndYiQUXdP0kJIa8+Aq1pE3V
         GzZU3weIZXMMROheSqUxkdi3iVsm1JKZ4dY3UMxzjFgbTWeTLNpdvPbEED9bqByqtBYG
         gixo/k3bWBV6UjzwFoGitxv9zPVlr5ZRG3ay6+h1oSxdBsanglF8mJi9eTgDxvVd3o2X
         Vagh3fTHE3UZrNqhRyy8tpJT6AI8dPuLRkMdZJgY5lFqvPTaAws02Sqyji1em5AnfdeT
         mgNd7vZQ48s/h2+u0yWQMF7NXgXgoCh7nTgOpa1D56KKcWONiv108+4daQEA0k361LYn
         m2Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jVv8AqSegnxp0gWnatsiyEbG1UXPWGptzgD/iRThcH0=;
        b=bzUiZy183IJNS2YunTbDytJuvoKyYQ843aq2qxhHizpdmRfmdIwt+pxPI/Lj8/+My5
         Z3VHf2IBI61Ob6Va1sUznZoh/GhuFuf2ScTit1EAuxPJ2x9AlYppyrR29bdG8uA9vxL9
         t48zUTdYTLvx4KVHcJnUvcGuFtKLQthy7F3oMwvCLuGEY9l1UN7qEuB2fjUKElQYVfrU
         YHvTcz9S9mhibskByEi8sAZl0eMEoYtQiarAULpvXm8so9nCT8vL6p8hbXEZ9WJEH4+E
         9YueVf1Swu+MW+oGf9SxT3Cwx94iecNK3IgO1UO5+xMChFRMQUr52M5hY2tRaIjQlw7o
         phfA==
X-Gm-Message-State: APjAAAWHu2PeqMfKkj+SjKWg0bK7eeYq+Qk5mKqDobWrbINMI2qfCk7w
        fBI9T1dxAHMpPr9g9JoYKgn1ML72
X-Google-Smtp-Source: APXvYqztb87AMgfKeuKKKHYfBTlwCvLWQMU/ZgIdjZXnTgIEo5CkZhbmNlHtm/GwVmYizH4niKSOQg==
X-Received: by 2002:adf:ea88:: with SMTP id s8mr1149170wrm.68.1561611313840;
        Wed, 26 Jun 2019 21:55:13 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id e11sm3264924wrc.9.2019.06.26.21.55.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 21:55:13 -0700 (PDT)
Date:   Thu, 27 Jun 2019 06:55:11 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Arkadiusz Drabczyk <arkadiusz@drabczyk.org>
Cc:     netdev@vger.kernel.org, jacmet@sunsite.dk
Subject: Re: dm9601: incorrect datasheet URL
Message-ID: <20190627045511.GA29016@Red>
References: <20190626141248.GA14356@comp.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626141248.GA14356@comp.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 04:12:48PM +0200, Arkadiusz Drabczyk wrote:
> http://ptm2.cc.utu.fi/ftp/network/cards/DM9601/From_NET/DM9601-DS-P01-930914.pdf
> is gone. In fact, document titled `DM9601-DS-P01-930914.pdf' is
> nowhere to be found online these days but there is
> http://pdf.datasheet.live/74029349/davicom.com.tw/DM9601E.pdf. I'm
> just not sure if this is the same document that the current link was
> pointing to and what does E suffix mean. There is also
> https://www.alldatasheet.com/datasheet-pdf/pdf/119750/ETC1/DM9601.html
> but notice that it says `Version: DM9601-DS-F01' on the bottom of some
> pages and `Version: DM9601-DS-P01' on others - I don't know what that
> means.
> 
> Should http://pdf.datasheet.live/74029349/davicom.com.tw/DM9601E.pdf
> be used as a datasheet URL?
> 

Hello

I have noticed the same problem some days ago.
The original datasheet could be found using archive.org.

I have downloaded all datasheets and none has the same md5, so it need a more detailled inspection.

Regards
