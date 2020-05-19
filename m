Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F851D912B
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 09:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgESHgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 03:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgESHgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 03:36:49 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35210C061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 00:36:49 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id nu7so960620pjb.0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 00:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0HhOQ6Ne72prSjzX/UUhIi0HOK0ASWxHC+btDL/2a3Y=;
        b=NakTREcykg60feJVOq7W9NPwP+9nPNgfXrru8GVC0OyGF7X5QHlKZsrFzJ4LB/lYcb
         J/OxfyQQVJUqkqPgSsrmeO7PUO1PYb/RZEA8HgUYuzW9IWikPkDDcPPLnKZoKsjmZ5kn
         DdU0L/7L212Q5Vin2hOFHpwCYBxIuT3pth0og=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0HhOQ6Ne72prSjzX/UUhIi0HOK0ASWxHC+btDL/2a3Y=;
        b=tyFqPa5+s2D9GchiemJj340g/UjCJVYjea3WArHFIfCdLlE073aC3dyDpdVAV8L7Vy
         rMI//fytHKhIeY10DuSuYq4dtt67xdmtdloArgoQTq/ws5HMg9jaGbq27QJDOHryrObJ
         ljuzO0GQqaV6+RbtZRkieghYLGhXaUMax3KqLTXSwiN+GEx33wab9VeYijxK1YZUt72t
         SPAgTmDML4uYevSVVuB2P7G2cnuNrnz4esZwYkuWzk7XBsdqF7gDhF+jkAbzsnlbxlgb
         YO24ZuHIAyUgTzj6RK8wmdwfLN63os1x+ghkkNA3veGIo3i7uFS7Nr4v+xBfcZLaMHSS
         P/HA==
X-Gm-Message-State: AOAM530o1MRWpi4YMGJlaGEXy81W2UROLdsA4xRlF0IAKh1sUSPEx+T8
        o3Te/0rvYrLb+EjBNzpjFaCHNaEwRjI=
X-Google-Smtp-Source: ABdhPJy9gk239cX3ycQdBssQV5N0Ptuc37r2rn/w9UvXiWxGcFhGaEOYXcxHrGTrN5yTczoWK0YDKQ==
X-Received: by 2002:a17:90a:2a03:: with SMTP id i3mr3636651pjd.29.1589873807940;
        Tue, 19 May 2020 00:36:47 -0700 (PDT)
Received: from noodle ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id i98sm1399298pje.37.2020.05.19.00.36.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 May 2020 00:36:47 -0700 (PDT)
Date:   Tue, 19 May 2020 10:36:38 +0300
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] __netif_receive_skb_core: pass skb by reference
Message-ID: <20200519073637.GB11263@noodle>
References: <20200518090152.GA10405@noodle>
 <22579c6e-76e2-51f3-5911-819784cd30cf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22579c6e-76e2-51f3-5911-819784cd30cf@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 08:59:56AM -0700, Eric Dumazet wrote:
> 
> Please provide a Fixes: tag for such a scary patch.

Done in v2.

Thanks,
Boris.
