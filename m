Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 422CC16F5D5
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 03:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbgBZCyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 21:54:45 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33303 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbgBZCyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 21:54:45 -0500
Received: by mail-pf1-f196.google.com with SMTP id n7so661162pfn.0;
        Tue, 25 Feb 2020 18:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WbBbZJtOAAR9ogSmr5inY5EiHXQEhBZaLqZLWsUeMHE=;
        b=Z8DLeQ8vr4YF3J/w3/lo+xEFAdWWokOTKo3Mqfc0IA4dpLgdjOC/XJBThtdjZEMzIp
         D2nw4fG2AFBeRDVIwePO+G8fsxbMgixyEy0yt5Pb1VOk/qSp1Sd1SvfSfcDD5bsfL2Nj
         MTBHgBehwVs/4AQcEbwR4w61KBZYMgVX2E+cBfYunc4e5+6rWhn9uhZz/aHPdF8ycGCa
         LJW1dIPll5dc6xE6UdT8NjKIeILz69ZhFScaF0mQkTM5Y4gRJ8JFf4VLxsQrwyxZmj9K
         E50108w4lLu3tQeNLmx7rVuVozH6UOimfgpCjSjn3UbFWUMyELMeiQdKavdivoQjDXl0
         BFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WbBbZJtOAAR9ogSmr5inY5EiHXQEhBZaLqZLWsUeMHE=;
        b=uSaA7jyNBussrtik20qnlXMFx3uezbvsfnOarIVa+FczjHZ6BrWLKrUl2EGfnWXQOw
         LQxxGFnLbOV578AgFFxkZ3UMx32/4Ethkxp6PyvhimZZ/dq0HNnsxaHm8js1b/fQ3xtC
         yUlb3nIobUWhzWIffCdGa7nQu7gnQtxqqjCoAOXmFCteNbu63yF0ydfwS1f/F+uSnubG
         paal/rGfel89pHc5bjsZ9dFdywK6Hc9Ic3v1e/sdZtb8ebae3DC3XvToLeEgaXYiwYYk
         aQOpTnFir6UZZ8D6VkL0tNAUYUHo0fs2dIZbGh22noq57T5/AgK0cCu+2gA9ymQLF+3P
         6rmA==
X-Gm-Message-State: APjAAAU9ETqYPr5AT1RPIfN+CDSrAPOxi0nzEH2o+4Y/0XHqvblLiuRC
        xYERwv+1vIKgD06tRIc8U3E=
X-Google-Smtp-Source: APXvYqzDRk/zvtkM2zUmDrx/sUc0QZV4NiKmSYZvj1fKG58TZ+GxwTXEgoX72xhH4fBHxsmcjdLrtw==
X-Received: by 2002:a63:8f1a:: with SMTP id n26mr1588449pgd.355.1582685683821;
        Tue, 25 Feb 2020 18:54:43 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id o36sm370352pgl.24.2020.02.25.18.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 18:54:43 -0800 (PST)
Date:   Tue, 25 Feb 2020 18:54:41 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH 0/2] AT8031 PHY timestamping support
Message-ID: <20200226025441.GB10271@localhost>
References: <20200225230819.7325-1-michael@walle.cc>
 <20200225235040.GF9749@lunn.ch>
 <9955C44A-8105-4087-8555-BAC5AE4AF25D@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9955C44A-8105-4087-8555-BAC5AE4AF25D@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 01:07:26AM +0100, Michael Walle wrote:
> Am 26. Februar 2020 00:50:40 MEZ schrieb Andrew Lunn <andrew@lunn.ch>:
> >That sounds fundamentally broken.

Right.  It can't work unless the PHY latches the time stamp.

> This might be the case, but the datasheet (some older revision can
> be found on the internet, maybe you find something) doesn't mention
> it. Nor does the PTP "guide" (I don't know the exact name, I'd have
> to check at work) of this PHY. Besides the timestamp there's also
> the sequence number and the source port id which would need to be
> read atomically together with the timestamp.

Maybe the part is not intended to be used at all in this way?

AFAICT, PHYs like this are meant to feed a "PTP frame detected" pulse
into the time stamping unit on the attached MAC.  The interrupt serves
to allow the SW to gather the matching fields from the frame.

Thanks,
Richard


