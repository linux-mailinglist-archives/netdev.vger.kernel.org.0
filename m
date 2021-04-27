Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6223536BE1B
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 06:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhD0EE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 00:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhD0EE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 00:04:28 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E8EC061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 21:03:44 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e14so24785797ils.12
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 21:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=E05xGxIDGN+hK7EZQDbumPO3b3Rcjn3nPcq7k5M0VR8=;
        b=E5p5PTBVNkEgcsRyKHOEOW6GMRBdcqMTjnKgICbFWhELtnwyiVLGXxjUW7jlPmMv17
         xFQ2nakGHgq4/lOSE7DRua41yqeQvmxLQioJ/OEYU0J1herPMXl7M2EquZdWMhTnlGVm
         B3BfuPEl9XNGj1ceq6XJBgELx2bz7bmZh2T4Eskh/hGmq5PytFPoxAwNnfpRUBb2P5MB
         Ibmo9PmVz0FUpUdyjRWUYQVjRh+MpGc+yb7M+tnVEwkp8lga1/XarXm8xsS7WEkqZdrP
         bUziLfl5cBQxiPifZWTu/sSrhvTkGQO6tZRWh1WwXwHjOpSGPRwZjUhTnSYKcyDFD2P7
         syvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=E05xGxIDGN+hK7EZQDbumPO3b3Rcjn3nPcq7k5M0VR8=;
        b=WRgF7IaFtUPwBPuZyaajTPdLvMm+dRgIASVp0vHZsPWGMlQRKt/OJ5ApDZ7RTPXk+l
         REpMZ+jqcgTWH05amHtWYo72Xl9uolzcgX8kbvS/4MHVVtZO8JYWHoG0IoK3ag1GbZfc
         9UIjdpxMUBaX8acc7cht12x8fridbjVVLSNGevi6izt+tbcchUNaXuPTDgj6s9F1BTq4
         YbBmWbxZ/3HgYaVDsMl8U5jEt3FGLIGwUVi/xPmGgnDI+mMSqwoAlPygJRYk6nfgt0z7
         NkJEqYgHBYuMkCkEjsSiVfwKgr7b5PlOx5Air4DX7/FimXPnwWKhFBE+FE98R3GBIX1L
         k0FA==
X-Gm-Message-State: AOAM532+bpaDZHXt/Uqw3MNtJoWpoDu4MIpxVmoFNhWB+defF32bQnRD
        6FSYzH2o2M/WL85qEmk3gWoKBYo0XbY=
X-Google-Smtp-Source: ABdhPJxJThc/M6meOIEOP1u8WX9OvybA48RumSypqEjWXr/xGHEh1gRThcqEkmNeTgXs60kUnGYPHQ==
X-Received: by 2002:a92:c791:: with SMTP id c17mr11486938ilk.107.1619496224240;
        Mon, 26 Apr 2021 21:03:44 -0700 (PDT)
Received: from ?IPv6:2601:681:8800:baf9:1ee4:d363:8fe6:b64f? ([2601:681:8800:baf9:1ee4:d363:8fe6:b64f])
        by smtp.gmail.com with ESMTPSA id g26sm8254660iom.14.2021.04.26.21.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 21:03:43 -0700 (PDT)
Message-ID: <c522ffcadf479c3f1a46c401e38ad01bf3f3331c.camel@gmail.com>
Subject: Re: [PATCH net-next] icmp: standardize naming of RFC 8335 PROBE
 constants
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Date:   Mon, 26 Apr 2021 23:03:43 -0500
In-Reply-To: <20210426205434.248bed86@hermes.local>
References: <20210427034002.291543-1-andreas.a.roeseler@gmail.com>
         <20210426205434.248bed86@hermes.local>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-04-26 at 20:54 -0700, Stephen Hemminger wrote:
> On Mon, 26 Apr 2021 22:40:02 -0500
> Andreas Roeseler <andreas.a.roeseler@gmail.com> wrote:
> 
> > The current definitions of constants for PROBE are inconsistent,
> > with
> > some beginning with ICMP and others with simply EXT. This patch
> > attempts to standardize the naming conventions of the constants for
> > PROBE, and update the relevant definitions in net/ipv4/icmp.c.
> > 
> > Similarly, the definitions for the code field (previously
> > ICMP_EXT_MAL_QUERY, etc) use the same prefixes as the type field.
> > This
> > patch adds _CODE_ to the prefix to clarify the distinction of these
> > constants.
> > 
> > Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> > ---
> >  include/uapi/linux/icmp.h | 28 ++++++++++++++--------------
> >  net/ipv4/icmp.c           | 16 ++++++++--------
> >  2 files changed, 22 insertions(+), 22 deletions(-)
> > 
> > diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
> > index 222325d1d80e..c1da8244c5e1 100644
> > --- a/include/uapi/linux/icmp.h
> > +++ b/include/uapi/linux/icmp.h
> > @@ -70,22 +70,22 @@
> >  #define ICMP_EXC_FRAGTIME      1       /* Fragment Reass time
> > exceeded */
> >  
> >  /* Codes for EXT_ECHO (PROBE) */
> > -#define ICMP_EXT_ECHO          42
> > -#define ICMP_EXT_ECHOREPLY     43
> > -#define ICMP_EXT_MAL_QUERY     1       /* Malformed Query */
> > -#define ICMP_EXT_NO_IF         2       /* No such Interface */
> > -#define ICMP_EXT_NO_TABLE_ENT  3       /* No such Table Entry */
> > -#define ICMP_EXT_MULT_IFS      4       /* Multiple Interfaces
> > Satisfy Query */
> > +#define ICMP_EXT_ECHO                  42
> > +#define ICMP_EXT_ECHOREPLY             43
> > +#define ICMP_EXT_CODE_MAL_QUERY                1       /*
> > Malformed Query */
> > +#define ICMP_EXT_CODE_NO_IF            2       /* No such
> > Interface */
> > +#define ICMP_EXT_CODE_NO_TABLE_ENT     3       /* No such Table
> > Entry */
> > +#define ICMP_EXT_CODE_MULT_IFS         4       /* Multiple
> > Interfaces Satisfy Query */
> >  
> >  /* Constants for EXT_ECHO (PROBE) */
> > -#define EXT_ECHOREPLY_ACTIVE   (1 << 2)/* active bit in reply
> > message */
> > -#define EXT_ECHOREPLY_IPV4     (1 << 1)/* ipv4 bit in reply
> > message */
> > -#define EXT_ECHOREPLY_IPV6     1       /* ipv6 bit in reply
> > message */
> > -#define EXT_ECHO_CTYPE_NAME    1
> > -#define EXT_ECHO_CTYPE_INDEX   2
> > -#define EXT_ECHO_CTYPE_ADDR    3
> > -#define ICMP_AFI_IP            1       /* Address Family
> > Identifier for ipv4 */
> > -#define ICMP_AFI_IP6           2       /* Address Family
> > Identifier for ipv6 */
> > +#define ICMP_EXT_ECHOREPLY_ACTIVE      (1 << 2)/* active bit in
> > reply message */
> > +#define ICMP_EXT_ECHOREPLY_IPV4                (1 << 1)/* ipv4 bit
> > in reply message */
> > +#define ICMP_EXT_ECHOREPLY_IPV6                1       /* ipv6 bit
> > in reply message */
> > +#define ICMP_EXT_ECHO_CTYPE_NAME       1
> > +#define ICMP_EXT_ECHO_CTYPE_INDEX      2
> > +#define ICMP_EXT_ECHO_CTYPE_ADDR       3
> > +#define ICMP_AFI_IP                    1       /* Address Family
> > Identifier for ipv4 */
> > +#define ICMP_AFI_IP6                   2       /* Address Family
> > Identifier for ipv6 */
> 
> You can't just remove the old constants. They have to stay there.
> The #defines are part of the Linux API by now.

Even in the case where these constants were added less than a month ago
(3/30/2021) and are not used elsewhere in the kernel? I agree with your
statement in the general sense, but I thought I could get ahead of it
in this case and update them.

For reference, they were added in commit
2b246b2569cd2ac6ff700d0dce56b8bae29b1842


