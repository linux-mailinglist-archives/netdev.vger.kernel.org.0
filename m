Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 056B011CBAC
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 12:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbfLLLBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 06:01:02 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:43446 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728423AbfLLLBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 06:01:01 -0500
Received: by mail-yb1-f196.google.com with SMTP id d34so274709yba.10;
        Thu, 12 Dec 2019 03:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3NLogIIkrt/hmZd7hzl4otAejKTvhVHjvTAan3q/U3Q=;
        b=U/MDo+ExHjLwBASvVMUbmdOjymwLMERC0Omm57dulGMVXjJprLZdP52/rBvSla++6o
         ru1Qbajslbn/FBW5TScyEMt5Sa7Ov0nI1b8aqBO3py3EcrvK060GiHRonnPiEbyHMGUl
         3yx8oLd+pwvpvcYTraRwRqBpiLiZuXdpYruWtQQF7ZBfNbFafd/iWbF0b2xPYdbT8L7x
         T81hbkYPB7X32Au0J9bUALVri+YtCM/oKYra9NTtdz1ZNglqIagk4ax6vkkF3lppmM67
         nimZ+NlE8oL00yPrDrR82o3pLR5q6s9KQN8tGvO6QnXT7EvRWaTl6W+48Xaz+kZbXSXu
         UIIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3NLogIIkrt/hmZd7hzl4otAejKTvhVHjvTAan3q/U3Q=;
        b=QgIA38D/oIQKO5VgsqpiY5kvUfEzsCsdHnkKZ+EV6aFm6+xPKxjc94XqzQkHshg3jE
         fHQcvScPSMKiekG+sjghJyudwGf+zoQTMx2ijIzykBPSeyPqp6PG6hrS9Lu6RbLm8ndw
         0+u93Rh3F4DWyzXUY5zIUYXtXvsuf6145gjFnABZz1BR/VOFXMK1fz5R8TFN5f5VzePU
         eBmIZo8ncfCV+8ca5NKf+WpwFgIPnts4wo9M84Vmjo8po5G041/6aEnHzz2bcjqv8cON
         5phxNKnfkjkGsRwgqEIdQjT1U2wZbX5V7t1hspQ+4bx7+OHhnpdhHloiltYSZGa85qLs
         9ldQ==
X-Gm-Message-State: APjAAAUF+Gtl0OvgpMyNCitffKxUPZI1ijyQlLfHEu6T1VYscx3htwxb
        XRrTF9985XEiewteuIjKMgzQGYq3JSILcg==
X-Google-Smtp-Source: APXvYqyCiWoYgW7gP5cqkOhfMLFAjSAYch+A+DHKKiWA9vs2WRbDV64ENGoizBVTkS6dMJh0fJ4+9w==
X-Received: by 2002:a25:6385:: with SMTP id x127mr3510081ybb.468.1576148460482;
        Thu, 12 Dec 2019 03:01:00 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:1549:e76:ca4c:6ce8])
        by smtp.gmail.com with ESMTPSA id 199sm2383432ywn.52.2019.12.12.03.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 03:00:59 -0800 (PST)
Date:   Thu, 12 Dec 2019 05:00:57 -0600
From:   Scott Schafer <schaferjscott@gmail.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     gregkh@linuxfoundation.org, Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 20/23] staging: qlge: Fix CHECK: usleep_range is
 preferred over udelay
Message-ID: <20191212110057.GA7934@karen>
References: <cover.1576086080.git.schaferjscott@gmail.com>
 <a3f14b13d76102cd4e536152e09517a69ddbe9f9.1576086080.git.schaferjscott@gmail.com>
 <337af773-a1da-0c04-6180-aa3597372522@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <337af773-a1da-0c04-6180-aa3597372522@cogentembedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 01:45:57PM +0300, Sergei Shtylyov wrote:
> Hello!
> 
> On 11.12.2019 21:12, Scott Schafer wrote:
> 
> > chage udelay() to usleep_range()
> 
>    Change?
> 
> > Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
> > ---
> >   drivers/staging/qlge/qlge_main.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> > index e18aa335c899..9427386e4a1e 100644
> > --- a/drivers/staging/qlge/qlge_main.c
> > +++ b/drivers/staging/qlge/qlge_main.c
> > @@ -147,7 +147,7 @@ int ql_sem_spinlock(struct ql_adapter *qdev, u32 sem_mask)
> >   	do {
> >   		if (!ql_sem_trylock(qdev, sem_mask))
> >   			return 0;
> > -		udelay(100);
> > +		usleep_range(100, 200);
> 
>    I hope you're not in atomic context...
> 
> >   	} while (--wait_count);
> >   	return -ETIMEDOUT;
> >   }
> 
> MBR, Sergei

Im not quite what you mean by "I hope you're not in atomic context",
could you please explain why you said this? 
