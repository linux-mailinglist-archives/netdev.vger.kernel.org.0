Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF168151A52
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 13:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgBDMJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 07:09:21 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21613 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbgBDMJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 07:09:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580818160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VdtGGv7KV015v5FjcF0j6xwOMCymK049rKOVAhVbF6c=;
        b=XCwAyKlZIQDg0cRTqNq5XmAE3NN8KWVl6daRwA0hNJn29Ca14pPobL/RgjjS71UbEWD0ey
        WdeXiNXg4SeAzRPG/wOCJRt/Zj4D9+30Z55fSHfq6Yi+rsUWGuN5BpYszPAFxdTRCKwHIH
        4heuyh3y4wTjkNXLg+i7EXoGE0DN08E=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-Kij2I71DMtKpgAltAaS8aw-1; Tue, 04 Feb 2020 07:09:17 -0500
X-MC-Unique: Kij2I71DMtKpgAltAaS8aw-1
Received: by mail-wr1-f71.google.com with SMTP id u8so9072764wrp.10
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 04:09:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VdtGGv7KV015v5FjcF0j6xwOMCymK049rKOVAhVbF6c=;
        b=udwKgbXCYTu3jFo58ZiFVw7g2kSse7GbISlksRl5p2gU9rhjvYvuFB/s5TM0Rk6V0B
         gA/CAROF9H7hXTgYPzGQssd+u6oLImMdMK+h0vOROUDOg6TX0bHMVfJtsn+t85dK/2D9
         XGwR9PkBAfmLCMYZeQwPrVPNNfliUo5znfaniAWI7QVeQJpca/3+waAt97zfxIwkudoD
         zLD/ptAaakHxXO72DI0YQ3BJWpowxhtJJfoiIkR9LddDmEX6bPteAe0c+vFpNZX0ePC4
         7yOR9oZCddj4y8qamwVpN/9mx6A1EVFnJz2tBeNg5CXqVtdyWHdJdJFIdOr+qHKK19hn
         sNuQ==
X-Gm-Message-State: APjAAAUyKzfKl1k6DeA+MFPWD7KBeH8wU7/FOL/TxE2MX47/158+Q0gj
        vl3S6VAOnlWtRK8m9euBIfFuO7LKtaig3pgwkGVRLR1oBx6XcF1IrI0iSO5cqC2uQhTwZZ0Vavb
        wmfWe45A8YqzdoK0a
X-Received: by 2002:a05:600c:21da:: with SMTP id x26mr5539036wmj.4.1580818155712;
        Tue, 04 Feb 2020 04:09:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqy3WSfOGVfd15+sBFZICZ3ba/LubyPLr02XDLgl3GagZjR73AzZudFseZUixsQio45DUIJ2aw==
X-Received: by 2002:a05:600c:21da:: with SMTP id x26mr5539022wmj.4.1580818155527;
        Tue, 04 Feb 2020 04:09:15 -0800 (PST)
Received: from pc-61.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id s16sm30614026wrn.78.2020.02.04.04.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 04:09:14 -0800 (PST)
Date:   Tue, 4 Feb 2020 13:09:12 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>
Cc:     netdev@vger.kernel.org, tparkin@katalix.com, jchapman@katalix.com
Subject: Re: [PATCH v2 net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200204120912.GA20493@pc-61.home>
References: <20200203232400.28981-1-ridge.kennedy@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203232400.28981-1-ridge.kennedy@alliedtelesis.co.nz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 04, 2020 at 12:24:00PM +1300, Ridge Kennedy wrote:
> In the past it was possible to create multiple L2TPv3 sessions with the
> same session id as long as the sessions belonged to different tunnels.
> The resulting sessions had issues when used with IP encapsulated tunnels,
> but worked fine with UDP encapsulated ones. Some applications began to
> rely on this behaviour to avoid having to negotiate unique session ids.
> 
> Some time ago a change was made to require session ids to be unique across
> all tunnels, breaking the applications making use of this "feature".
> 
> This change relaxes the duplicate session id check to allow duplicates
> if both of the colliding sessions belong to UDP encapsulated tunnels.
> 
Thanks Ridge.

Even though it's already applied,
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Tested-by: Guillaume Nault <gnault@redhat.com>

