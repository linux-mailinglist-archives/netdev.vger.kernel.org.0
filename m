Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F61A407087
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 19:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhIJR3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 13:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbhIJR3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 13:29:44 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D1DC061574;
        Fri, 10 Sep 2021 10:28:33 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id g14so4371018ljk.5;
        Fri, 10 Sep 2021 10:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=BhHuc7Cjlx8Uws6mK4+1ThnTH6hFaC10ASuiWh5hFCE=;
        b=qv45Ea7vxtjrefJIVv+WLaFopsIDKTCxymXO09US5GHfhMRQuyrbFRdu6vsgzmw8DP
         AL1gl3Ueh2BU2Ns4o19SrnIgkBGL43SA4oKjCr6rAEtY7tPHLCWlsj+z7PgYw05gJB8r
         rsBZP54+dj/W8RN2lWD6b39zTUX3uu1zRfkJJtG7SAkU/Qp8AmMU511lkzog97/WhFmv
         65u3Aoxbld2gAfBEW7LjS7MytBgCyIYt0voqfUshYcUSFZsA6eZcXkNJxy0AOQTkdYXb
         htqz9ndrBQR8HJI3Yex9KbVJD+18E/A0HCDdg6N8oycPTE6y0I3PvyQ0RLhcLqHXqxPC
         sonw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=BhHuc7Cjlx8Uws6mK4+1ThnTH6hFaC10ASuiWh5hFCE=;
        b=TwMJUracyfEzeZK61n0hXEkGNfVFAZ5tV6WcQfxRl9kIazgy6Avf7p/XwZ4rXh2+BB
         GWH5xLWcXK90SzmqsTgMdL4oMMdwik/rTdxg3m0hisKN2zLK90hWvVZlQeLeckZRZ6k9
         rI8STtF6rPGJnQfGdmLfndsiVy+qx7bMZ8WllKceWrhR1v2eMECVJtDazpp0XXAbWjmX
         LhHTqDiGYcA7UB+QXC0RgtwqIMu6ICLsmM8I7nSkW80Icxj6UXNln+dqt6oGTcc0yZcX
         4d0TDJfwN+4IntL3huSGP3QNQn52qhzk5ZivX+rCQgdS21hrDL2bYbxPLUUSTxMGl412
         TGZw==
X-Gm-Message-State: AOAM530I7syzFYaUN+V2nyMJrsKEmwdc1Y//hZwdDySqWHQCuRG16ENO
        d7dgSr4a3mxqPnX6bFgyKUwJSenB8yCZeQ==
X-Google-Smtp-Source: ABdhPJwSBQ6v5ZHbTXA6zQuREQfbmodC2z+uYCqtOijsZuoj7lR2ycruSDUwnEKdi4BdxWj+lDKklQ==
X-Received: by 2002:a2e:8511:: with SMTP id j17mr4954431lji.407.1631294911915;
        Fri, 10 Sep 2021 10:28:31 -0700 (PDT)
Received: from kari-VirtualBox ([31.132.12.44])
        by smtp.gmail.com with ESMTPSA id t11sm614979lfc.54.2021.09.10.10.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 10:28:31 -0700 (PDT)
Date:   Fri, 10 Sep 2021 20:28:29 +0300
From:   Kari Argillander <kari.argillander@gmail.com>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 31/31] staging: wfx: indent functions arguments
Message-ID: <20210910172829.3ulrvnl7d5kz43wt@kari-VirtualBox>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
 <20210910160504.1794332-32-Jerome.Pouiller@silabs.com>
 <20210910165743.jm7ssqak7gouyl5j@kari-VirtualBox>
 <2462401.Ex1rHSgKji@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2462401.Ex1rHSgKji@pc-42>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 07:12:28PM +0200, Jérôme Pouiller wrote:
> On Friday 10 September 2021 18:57:43 CEST Kari Argillander wrote:
> > 
> > On Fri, Sep 10, 2021 at 06:05:04PM +0200, Jerome Pouiller wrote:
> > > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > >
> > > Function arguments must be aligned with left parenthesis. Apply that
> > > rule.
> > 
> > To my eyes something still go wrong with this patch. Might be my email
> > fault, but every other patch looks ok. Now these are too left.
> 
> I don't try anymore to check alignments with my email viewer. The
> original patch is as I expect (and I take care to send my patch with
> base64 to avoid pitfalls with MS Exchange). So, I think the is correct.

It was correct. Nice to now know about that something funny is happening
with my part.

> 
> > Also it should alight with first argument not left parenthesis?
> 
> Absolutely.
> 
> 
> -- 
> Jérôme Pouiller
> 
> 
