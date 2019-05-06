Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 470DB154E3
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 22:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfEFU2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 16:28:53 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:55134 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfEFU2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 16:28:53 -0400
Received: by mail-it1-f193.google.com with SMTP id a190so22621611ite.4
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 13:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fBbI/qcAvKvk05jnDkbLDq7pl64ZpI8aJ+Db8H41XOA=;
        b=TdtaZtOxWsuPFHEKYV6Z1MYa7vte83NMw2/LLSq9rZOwMw0lTKqX/5JN3woHoECPK7
         6ScrtKIl0jUbXnS+2sRyWejTFUiVfD+SB4cWTBvQuvvXAoNZX9EoJzSXhLRK0uYTatY8
         asnGW6jC6emVzJrKBYsoP0rr3LP8TNRFyPCwJ/2sctTMtvB/8MeuEYEpEHeIGSAnYdd0
         feSf9PMur48nHwCtArpphoAv9Yvs1eqlNfVWbUu/cFFm9LFt1xchauzraEYF2SaWRYdq
         +qWI1WmxCoeY+Zt1SQMa8Nq6UlRP9BVJDlNwRYDqFzCEEkjn7p45WLtGiqUVSnFhXFF1
         u8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fBbI/qcAvKvk05jnDkbLDq7pl64ZpI8aJ+Db8H41XOA=;
        b=JdqBWhedED1iqGsMuIHM2oz/X+sw+nFu4Z8I318Y4ZSeWaLBlcy56NETiJbeCl7Qx/
         Szd4CKM8vNktf3RGpbePYFcsFnVinBFzFLJP7rTZHLUw21r6Qs+mSBP0pFVIRduPI8cq
         i1WelPBOP8XVCw3eDBdn1bKRJvOpysgTx84O9Dv3vhWk3zpyWk5eXwoLlQ9+55+89HoY
         QYIESAdekQfb+DIhzV/4Axl+EdD8nSdwwtQkd7vDF0dU6PXmIbWtlfk+W+PDtkjuEUzR
         rBXtWUpmYV3agKLFaawS6XfaCdQla3ZvZSP3jhZ5c6Em/HbqQnQ4T3xOkL69PM+5m9Zr
         14Jg==
X-Gm-Message-State: APjAAAVugjXew5/5H0N/23UJ6tzp7iTRo7YSzUpUWx5K0vlzjs1u0ByT
        MwPhmmxoId9wkveSEXgvog==
X-Google-Smtp-Source: APXvYqw0IB60QWhjqfUiVIYVuwS9L0E18A87bX/X1S00r6RqwxPIIbyUy/XypyYrG/YQH06KL1gjlg==
X-Received: by 2002:a05:660c:9c2:: with SMTP id i2mr13894689itl.80.1557174532488;
        Mon, 06 May 2019 13:28:52 -0700 (PDT)
Received: from ubuntu ([12.38.14.10])
        by smtp.gmail.com with ESMTPSA id a21sm4037207ioo.68.2019.05.06.13.28.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 13:28:51 -0700 (PDT)
Date:   Mon, 6 May 2019 16:28:48 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] vrf: sit mtu should not be updated when vrf netdev
 is the link
Message-ID: <20190506202848.GA19038@ubuntu>
References: <20190506190001.6567-1-ssuryaextr@gmail.com>
 <667fd9b5-6122-bd9f-e6ae-e08d82197ef9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <667fd9b5-6122-bd9f-e6ae-e08d82197ef9@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 01:54:16PM -0600, David Ahern wrote:
> On 5/6/19 1:00 PM, Stephen Suryaputra wrote:
> > VRF netdev mtu isn't typically set and have an mtu of 65536. When the
> > link of a tunnel is set, the tunnel mtu is changed from 1480 to the link
> > mtu minus tunnel header. In the case of VRF netdev is the link, then the
> > tunnel mtu becomes 65516. So, fix it by not setting the tunnel mtu in
> > this case.
> > 
> > Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> > ---
> >  net/ipv6/sit.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> > index b2109b74857d..971d60bf9640 100644
> > --- a/net/ipv6/sit.c
> > +++ b/net/ipv6/sit.c
> > @@ -1084,7 +1084,7 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
> >  	if (!tdev && tunnel->parms.link)
> >  		tdev = __dev_get_by_index(tunnel->net, tunnel->parms.link);
> >  
> > -	if (tdev) {
> > +	if (tdev && !netif_is_l3_master(tdev)) {
> >  		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
> >  
> >  		dev->hard_header_len = tdev->hard_header_len + sizeof(struct iphdr);
> > 
> 
> can you explain how tdev is a VRF device? What's the config setup for
> this case?

Hi David,

tdev is set to VRF device per your suggestion to my colleague back in
2017:
	https://www.spinics.net/lists/netdev/msg462706.html.
Specifically this on this follow up:
	https://www.spinics.net/lists/netdev/msg463287.html

His basic config before your suggestion is available in:
	https://www.spinics.net/lists/netdev/msg462770.html

He and I had a refresher discussion this am trying to figure out if tdev
should be a slave device. This is true if the local addr is specified.
In this case the addr has to bound to a slave device. Then the underlay
VRF can be derived from it. But if only remote is specified, then there
isn't a straightforward way to associate the remote with a VRF unless
tdev is set to a VRF device.
