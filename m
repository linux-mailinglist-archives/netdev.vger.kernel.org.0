Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B01B6121909
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 19:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbfLPSsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 13:48:11 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40318 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbfLPSsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 13:48:10 -0500
Received: by mail-qk1-f194.google.com with SMTP id c17so5287932qkg.7;
        Mon, 16 Dec 2019 10:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=d/igsJxqxIH045Qz270VUKi+p6ksbRkZVV5S40MrKR0=;
        b=aIElbB20MoCu/or0OwrNw58y+Pg3hIIlkOwBtccZPvB4GFLh3s6oDd1lzbEkQfOmcM
         pruMrgmKjg4ERFO3kP0Cv4ulwcsKojU/ZxOyJ/Jf95ZuyM44Yzs87kA56E1kx4oWGldu
         +6mw96JYiFfzPk4jbibswXQfyTHTbQdKY33o7wWH+auioeMDoPp2QRWq1uZCUa/+mRmX
         WBal1dDIzfIRe98HdKtXkyJW1g9qImdUl0YDmvsxUoPWx5h90u4YxLpIj/qrNJLzZpEa
         cs8mNp1fCsN30L3LtYiB6JX22XNLkNjATFx/r5Pym1QPvofhCCWLm8K1b1GewA5qRB9F
         Oh+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=d/igsJxqxIH045Qz270VUKi+p6ksbRkZVV5S40MrKR0=;
        b=mKLT29Jrrf/KR1AwdFCJ4dTlnj5bMJrgrjqJmtrU4Ti8hrJp6rhjl2d2RqTmSgkCZD
         aAQo4XNxD6S1yAWPLv4AEsDr5O86C9EI4XJUl/6OGdt73pnOmXjN4B5xIFoVOMks8cwT
         0AKbMuOsVmKoxkK/zR+aOOb7lTrws64W7PTCLW9EMn47Yo5rJyTh+S1fc9iHF834whjk
         CwV8qu3HL3x3P7l8UqqcoB3x/dbwnIw6fJkHFGCKprO1MRBUCzNlP4IByofCN6ILAstz
         dRbV46ict/k6nMhx453AGN+UpwJxWv/5qgk7jA2KjeDb+hG8gLLdS9sEvoArz5vKW8Ts
         PbYA==
X-Gm-Message-State: APjAAAVL66ggbCUxxtyAhiwtWJcE0+22fh5XwDLASeczOB7Q4cqAZZO/
        b+0sKxNVZT6Jy6CMj28svZ8=
X-Google-Smtp-Source: APXvYqwu1Nj38YMaqxbNMuATZpIQW7jHHzmLSWJBFyAMPr6tHGWaL7q4jbeEj8hy7h3hDnEw/949oA==
X-Received: by 2002:a37:4a0d:: with SMTP id x13mr807474qka.332.1576522089932;
        Mon, 16 Dec 2019 10:48:09 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id u24sm6315073qkm.40.2019.12.16.10.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 10:48:09 -0800 (PST)
Date:   Mon, 16 Dec 2019 13:48:08 -0500
Message-ID: <20191216134808.GB2070741@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        ioana.ciornei@nxp.com, olteanv@gmail.com,
        jakub.kicinski@netronome.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: Make PHYLINK related function static
 again
In-Reply-To: <20191216183248.16309-1-f.fainelli@gmail.com>
References: <20191216183248.16309-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 10:32:47 -0800, Florian Fainelli <f.fainelli@gmail.com> wrote:
> Commit 77373d49de22 ("net: dsa: Move the phylink driver calls into
> port.c") moved and exported a bunch of symbols, but they are not used
> outside of net/dsa/port.c at the moment, so no reason to export them.
> 
> Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
