Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 358B717012B
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 15:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgBZO3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 09:29:35 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34710 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727446AbgBZO3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 09:29:34 -0500
Received: by mail-pl1-f193.google.com with SMTP id j7so1368166plt.1;
        Wed, 26 Feb 2020 06:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VqCNHA5h8w+jm4PEJVkZoEzMGjj3RusmfQpFcLz71kQ=;
        b=SxlL7VL7qMqN83Vvso8hSUbi49hAYfEoUzYu2R9ZrI87aIqWlHEMOd+fWOEDZRtYcC
         q8dF3Mc/SVl3ZLi6h4yBCSH9mmhrhMGC8muEF5fhutVMAhhtSnePySit4x9ZpahsNeBl
         nfasVgP3+25T/aCSV4MW8U2Nr6VdgAM8LkXbZs0aGBkSzYyzLOcwU2jn62HDDEBgcRmN
         YZxKLp0HjFu1+N3Vf5X9xC39Wf1FLxa2yOoQaWMAWMp5reXN1/tStA+V4OLYFFzNwYon
         qOsOowJ827TjvbYPr1EO2he+3fNAm/EjyYyzE/IbyBZ0HXOrO28FEcPJVn8uacHVQZ2O
         eqFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VqCNHA5h8w+jm4PEJVkZoEzMGjj3RusmfQpFcLz71kQ=;
        b=R5do90R0dRTG1zInFSZBgqMXJu+9J9Euw2udEcCtSvafbKnAm0Hl6LJHN46j6hvNt4
         c9kKo5MNfaJ7sO3rJiHHBYTQCaFeoRyvsDafHcsa69EsqPmz6BpqszEmxMrCEYgE6J35
         lyX51bG37f6aYCukeKo9+Da7SsND5Gh40GtDzUmLOdAsSPqv2goIx0LTU2HkpRPBuO8S
         Rwsd4Peg72sGGf4HEhBwTveysrlH9ziBZ5GNYTkm7zrZlv7hhCNdCXeH+mLawY/xramV
         nPN5UhxjCmI8qJ86ye6dUGfL1d+w5WJkhrRPKHdYTqGNCrlHo936SVul6eUUNEgZhmAo
         +Dlw==
X-Gm-Message-State: APjAAAUBssNcZl+p1jD59NFlkfotaUxjv4scQd57N0YfOYLVe3TuRvcU
        IwpGMikDjhpgPhm1dXcsq6g=
X-Google-Smtp-Source: APXvYqztqKU513mEFFjaQWr9RgsHnllKC23sYhZpMCUvhDkSE1h5hMSHaBx6pYKtZqThoiQ1HEkUhQ==
X-Received: by 2002:a17:90a:e653:: with SMTP id ep19mr5755339pjb.58.1582727373802;
        Wed, 26 Feb 2020 06:29:33 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id u23sm3281311pfm.29.2020.02.26.06.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 06:29:33 -0800 (PST)
Date:   Wed, 26 Feb 2020 06:29:31 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH 0/2] AT8031 PHY timestamping support
Message-ID: <20200226142931.GA1651@localhost>
References: <20200225230819.7325-1-michael@walle.cc>
 <20200225235040.GF9749@lunn.ch>
 <9955C44A-8105-4087-8555-BAC5AE4AF25D@walle.cc>
 <20200226025441.GB10271@localhost>
 <fa823a08fa6d50c57ca03bdc58bf4921@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa823a08fa6d50c57ca03bdc58bf4921@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 12:30:48PM +0100, Michael Walle wrote:
> But then there would need to be such a hardware pin, correct? Unless
> you'd misuse the INT# for it. Also, why should the PHY then have a PHC
> which can be adjusted.

I see.  Oh well.  I'll just have to remember the AR8031 on my list of "ptp
hardware to be avoided".

:(

Richard
