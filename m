Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4079123342
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 18:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfLQRPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 12:15:47 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42710 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfLQRPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 12:15:46 -0500
Received: by mail-pg1-f196.google.com with SMTP id s64so6003126pgb.9
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 09:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=xF3Ny7ZnnbPuXpJw2vfE6lN5ovTpLxU4+wWaGrKXERY=;
        b=CfZ0zRQ1qIuyS98KtHka1G6zOW+A2YgtxOjfIwu1J2b32kJF5mwwCS9pKHx6z5uyhO
         uciHjmN0ESlz2Xau+KeYIC86qgNFouKwpi9lgJpzkdzQVfzDpqP75OqmhEVSwz0NTlkh
         eGWczGMyAlCIZiN5pu0TN++2qIGDV7Vfe3YCV2noOfD3Wy45fl8IPoPAlDsH3b9plEPU
         1Fme4z0EaXxTipLbUfLK6T3LexpPwIp9HhT4t0VtE5tKtirVXS2HqrV17rUvwev29sBH
         QfwS9M1beVgWSAzTG2WCQJkcJ940D1Y3RyIsrcG7cyz4odYtgNyIbG1RpGjmwiboNrTN
         DSQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=xF3Ny7ZnnbPuXpJw2vfE6lN5ovTpLxU4+wWaGrKXERY=;
        b=qjLa72Z6cg3Sqy+WhMx6JgGL5Pd3JcNkTID13vBble9OZpiJh4XNtqxd4eVbYQITpK
         I+6yhKhLOS6Nm0EyM5g5E9b3HuZW41Q9hTaB1dJ4Eg6jo3o8b7o5l9CppJg+calInGJt
         MKuq1Nd78aKFd3yhv3M0Ys6HubZothMacpc/1ETui606sJPxVsxsw3jILW+wsDHaVn94
         nGM02GsvN3F+W3oWi3VWXRvqpztFFbKBHFYQpGCjaHjFPuCl3itLxNxAtfjqhM+6Tb87
         AM3QcLRaxJ4phFJIXVoYhPzyZaX+oA0cSupXab4cESGiFzCPBqNuTv40RUvUzoMxfneM
         y4jQ==
X-Gm-Message-State: APjAAAUq0LOWWucEZ7dTeZ5fgphSzFj8rDozXAQeXg6Dz4HmeV6Y1+aQ
        wsRSmyRwRYeqZf2zVkeWN0M=
X-Google-Smtp-Source: APXvYqz/pRdjlnBp3aS18IDqgUZ3mDsHox8+M0GkiAwtOAPPPWpTK0poBA6wCGmU1Ci1wqNBVDB5WA==
X-Received: by 2002:a63:2355:: with SMTP id u21mr25801992pgm.179.1576602945979;
        Tue, 17 Dec 2019 09:15:45 -0800 (PST)
Received: from martin-VirtualBox ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id f127sm25165583pfa.112.2019.12.17.09.15.44
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 09:15:45 -0800 (PST)
Date:   Tue, 17 Dec 2019 22:45:39 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next v3 3/3] openvswitch: New MPLS actions for layer
 2 tunnelling
Message-ID: <20191217171539.GA16538@martin-VirtualBox>
References: <cover.1576488935.git.martin.varghese@nokia.com>
 <9e3b73cd6967927fc6654cbdcd7b9e7431441c3f.1576488935.git.martin.varghese@nokia.com>
 <20191216161355.0d37a897@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191216161355.0d37a897@cakuba.netronome.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 04:13:55PM -0800, Jakub Kicinski wrote:
> On Mon, 16 Dec 2019 19:33:43 +0530, Martin Varghese wrote:
> > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> > index a87b44c..b7221ad 100644
> > --- a/include/uapi/linux/openvswitch.h
> > +++ b/include/uapi/linux/openvswitch.h
> > @@ -673,6 +673,25 @@ struct ovs_action_push_mpls {
> >  };
> >  
> >  /**
> > + * struct ovs_action_ptap_push_mpls - %OVS_ACTION_ATTR_PTAP_PUSH_MPLS action
> > + * argument.
> > + * @mpls_lse: MPLS label stack entry to push.
> > + * @mpls_ethertype: Ethertype to set in the encapsulating ethernet frame.
> > + * @l2_tun: Flag to specify the place of insertion of MPLS header.
> > + * When true, the MPLS header will be inserted at the start of the packet.
> > + * When false, the MPLS header will be inserted at the start of the l3 header.
> > + *
> > + * The only values @mpls_ethertype should ever be given are %ETH_P_MPLS_UC and
> > + * %ETH_P_MPLS_MC, indicating MPLS unicast or multicast. Other are rejected.
> > + */
> > +struct ovs_action_ptap_push_mpls {
> > +	__be32 mpls_lse;
> > +	__be16 mpls_ethertype; /* Either %ETH_P_MPLS_UC or %ETH_P_MPLS_MC */
> > +	bool l2_tun;
> 
> In file included from <command-line>:32:                                        
> ./usr/include/linux/openvswitch.h:674:2: error: unknown type name ‘bool’        
>   674 |  bool l2_tun;                                                           
>       |  ^~~~                                                                   
> make[3]: *** [usr/include/linux/openvswitch.hdrtest] Error 1  
> 

Does that mean bool cannot be used in interface header files ? but what is
the alternative u8?
> > +};
> > +
> > +
> 
> Why the double new line? Please use checkpatch --strict.

Noted

Thanks for your time.
