Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB811046F0
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 00:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfKTXZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 18:25:57 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45898 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfKTXZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 18:25:57 -0500
Received: by mail-lj1-f196.google.com with SMTP id n21so1002032ljg.12
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 15:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=uJHVsvJGtaJq24DiJ+xKCut9DB1AUz5pYak/fh8B79I=;
        b=fGSRyIR9YLdEQ1jnm8u7ISFeCXmyNudDo0QCjzBQTSPgHg40+H1CcGmfizr8vzwylF
         Oh23DWBPwjk1ENUNvQLeKy3UjxOjUs+auiHbhXEBhneINVuh4RqT4WufJi1W4WtQJXjb
         XSBeTWPT5fu+9i9/vUOmCfPonGbWCq2cok8Fr47pbtVS7Wz8Qe8eXLo+y6YPelEOt7b9
         cc2E3TnhUHFuA0twYMXV94cgaE0Ss051FJvWlu0fAkwXnTVNT9TZ87NhnoEfi9psl+u6
         NPZpIuoqhWxaQ2cKBTZS44f9l44U8WbaHM1a4IEQcBdkZQJnye2ZrsdF82t7zIx3WZ4R
         fQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=uJHVsvJGtaJq24DiJ+xKCut9DB1AUz5pYak/fh8B79I=;
        b=E8iDpQ4IzuKiJcPuyaeNIHt+hZzeGLhQT8Bqrez9TIjPUTYQeuG3KmsTN7bsR6rh1p
         WdRt+lWy5qO1mIwAxOmCk5R9vvNQxseoksVbDxDWMwBBb1NcrczB5KufKfTUlRSFQR3q
         NNP3+E3JzR+ulEx62uuPh67rgQnqiZ4zSo3ZOZWIi4eNSj2nkEPi6lfC6NEPbLAqER4P
         n9XIqCCPnXd72kTl3G51+4TU8iwroF/lLp3IVVC3PkqbAV3VoMVB1g4DlFYDKkPDP/1s
         QnSUIlZ/vZVnbXeTDZXTpXM9GRQrtkkLTBqoxX3+9uwMS1MJHF1fiy/KiuNP0sD6N2l+
         hyyg==
X-Gm-Message-State: APjAAAU8im1NWizw4gMxD7GW3Mb5qf7vxkKzYOt6is2DrWw2LWxjdZV+
        0Lazywh6byJcZLd1FAumSj4ppUDlXZ0=
X-Google-Smtp-Source: APXvYqw4KXpqK8jvJUvgZYkJMcUu+hm7dsRGiQ40wBJ1gr+8iHuj+VQ73nfUP6sg30oofG/a3rdKOQ==
X-Received: by 2002:a2e:98c6:: with SMTP id s6mr4411422ljj.235.1574292352843;
        Wed, 20 Nov 2019 15:25:52 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t14sm244094lfg.30.2019.11.20.15.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 15:25:52 -0800 (PST)
Date:   Wed, 20 Nov 2019 15:25:34 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Petr Machata <petrm@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [RFC PATCH 00/10] Add a new Qdisc, ETS
Message-ID: <20191120152534.2041788e@cakuba.netronome.com>
In-Reply-To: <cover.1574253236.git.petrm@mellanox.com>
References: <cover.1574253236.git.petrm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 13:05:08 +0000, Petr Machata wrote:
> The IEEE standard 802.1Qaz (and 802.1Q-2014) specifies four principal
> transmission selection algorithms: strict priority, credit-based shaper,
> ETS (bandwidth sharing), and vendor-specific. All these have their
> corresponding knobs in DCB. But DCB does not have interfaces to configure
> RED and ECN, unlike Qdiscs.
> 
> In the Qdisc land, strict priority is implemented by PRIO. Credit-based
> transmission selection algorithm can then be modeled by having e.g. TBF or
> CBS Qdisc below some of the PRIO bands. ETS would then be modeled by
> placing a DRR Qdisc under the last PRIO band.
> 
> The problem with this approach is that DRR on its own, as well as the
> combination of PRIO and DRR, are tricky to configure and tricky to offload
> to 802.1Qaz-compliant hardware. This is due to several reasons:
> 
> - As any classful Qdisc, DRR supports adding classifiers to decide in which
>   class to enqueue packets. Unlike PRIO, there's however no fallback in the
>   form of priomap. A way to achieve classification based on packet priority
>   is e.g. like this:
> 
>     # tc filter add dev swp1 root handle 1: \
> 		basic match 'meta(priority eq 0)' flowid 1:10
> 
>   Expressing the priomap in this manner however forces drivers to deep dive
>   into the classifier block to parse the individual rules.
> 
>   A possible solution would be to extend the classes with a "defmap" a la
>   split / defmap mechanism of CBQ, and introduce this as a last resort
>   classification. However, unlike priomap, this doesn't have the guarantee
>   of covering all priorities. Traffic whose priority is not covered is
>   dropped by DRR as unclassified. But ASICs tend to implement dropping in
>   the ACL block, not in scheduling pipelines. The need to treat these
>   configurations correctly (if only to decide to not offload at all)
>   complicates a driver.
> 
>   It's not clear how to retrofit priomap with all its benefits to DRR
>   without changing it beyond recognition.
> 
> - The interplay between PRIO and DRR is also causing problems. 802.1Qaz has
>   all ETS TCs as a last resort. I believe switch ASICs that support ETS at
>   all will handle ETS traffic likewise. However the Linux model is more
>   generic, allowing the DRR block in any band. Drivers would need to be
>   careful to handle this case correctly, otherwise the offloaded model
>   might not match the slow-path one.
> 
>   In a similar vein, PRIO and DRR need to agree on the list of priorities
>   assigned to DRR. This is doubly problematic--the user needs to take care
>   to keep the two in sync, and the driver needs to watch for any holes in
>   DRR coverage and treat the traffic correctly, as discussed above.
> 
>   Note that at the time that DRR Qdisc is added, it has no classes, and
>   thus any priorities assigned to that PRIO band are not covered. Thus this
>   case is surprisingly rather common, and needs to be handled gracefully by
>   the driver.
> 
> - Similarly due to DRR flexibility, when a Qdisc (such as RED) is attached
>   below it, it is not immediately clear which TC the class represents. This
>   is unlike PRIO with its straightforward classid scheme. When DRR is
>   combined with PRIO, the relationship between classes and TCs gets even
>   more murky.
> 
>   This is a problem for users as well: the TC mapping is rather important
>   for (devlink) shared buffer configuration and (ethtool) counters.

IMHO adding an API to simplify HW config is a double edged sword. 
I think everyone will appreciate the simplicity of the new interface..
until the HW gets a little more smart and then we'll all have to
go back to the full interface and offload both that and the simple one,
or keep growing the new interface (for all practical sense just for HW)
Qdisc.

Having written a MQ+GRED offload I sympathize with the complexity
concerns, also trying to explain how to set up such Qdiscs to users
results in a lot of blank stares.

Is there any chance at all we could simplify things by adding a better
user interface and a common translation layer in front of the drivers?
