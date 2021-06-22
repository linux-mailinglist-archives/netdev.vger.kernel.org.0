Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7053AFA9B
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 03:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhFVBcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 21:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhFVBcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 21:32:36 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6CCC061574;
        Mon, 21 Jun 2021 18:30:20 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id j184so35469742qkd.6;
        Mon, 21 Jun 2021 18:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P1T3GyRhBi7GEl+St9OfKiYv0CVkyOTJ8xac8/yyCss=;
        b=bBRP+3kP2Ehu+3mITOtC1wvmuxEXCHjzPiSWtEORsaMU8D62FrFZIO3wHfpTeQ7EwI
         02FQhuDDlXrLeL2evsMEgPvr0FyYrglLdFmLdICN9AZknc1IeCQZcuzHxW+RB3T7CDni
         VlTGsQUH3vmD0Pfqi5EdI6FhrG6/26oy8zeXF1if4EBuTimUKUrEaza9o2M7mPV2Dx/v
         HTyuh+4Gb1RP1OhLVanbUs7AbA0jZIQGi5jLQ434Nw71W3EsCBcqI6RQ9KxMoRf1CJI+
         FLw6jkdzdNHt9tVas8ier3xj7SI6VELjN0nkDA4AVh+UbTiPHlLwuaMrjp3N7DwALqUb
         eiLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P1T3GyRhBi7GEl+St9OfKiYv0CVkyOTJ8xac8/yyCss=;
        b=Cy3UxVnlrOFeq67JFnoz6wg1erhrXjSQE+waXYaOOVXzGNxHi69FMyhnHuC3PRviik
         ZOkKN+U/MiLV6xs1tBMJWcWCLskGqo3guwEUccrlULXmQ4KCa7Mp57eksxd5pA2gf/Ay
         4Lxx6qEUDwjrHKqlnmz52SRJ5/Ci93ejprlv9pGSQMk6OYj9UilAHTk3DhcN79/ebYnp
         zCgKNj9N41Lx+gFQYEDFMrdiSXS0WgPigaBx2yNWsRDPcHvrIbTQjOCsV86isoaiSCG/
         5EN9832HG0aLlJaw3dS8uosCBuboaojk7JEth7trn1ct4hzv6KEc90IRSPL9Oz6g6Raw
         dWMA==
X-Gm-Message-State: AOAM530xDS+qxZbul0CiCkgg8CDJAP/quS0FXjr5K9tguWVjbNRWEY+S
        wD7oC9/ZZ8hhP/Yc2iiRdkBrbqv2A26OOg==
X-Google-Smtp-Source: ABdhPJxJfQqBvL41zgDTkD4oinyAdQ1CkAuqtljnq8svjcKeSPzH4ett7D97XAPPmxzuCsDFo81Nmg==
X-Received: by 2002:a05:620a:c8c:: with SMTP id q12mr1704602qki.203.1624325419845;
        Mon, 21 Jun 2021 18:30:19 -0700 (PDT)
Received: from horizon.localdomain ([177.220.172.71])
        by smtp.gmail.com with ESMTPSA id s133sm11326973qke.97.2021.06.21.18.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 18:30:19 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 1BE63C02A9; Mon, 21 Jun 2021 22:30:17 -0300 (-03)
Date:   Mon, 21 Jun 2021 22:30:17 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next 00/14] sctp: implement RFC8899: Packetization
 Layer Path MTU Discovery for SCTP transport
Message-ID: <YNE9KTlOkzUjgr4c@horizon.localdomain>
References: <cover.1624239422.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1624239422.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 20, 2021 at 09:38:35PM -0400, Xin Long wrote:
> Overview(From RFC8899):
> 
>   In contrast to PMTUD, Packetization Layer Path MTU Discovery
>   (PLPMTUD) [RFC4821] introduces a method that does not rely upon
>   reception and validation of PTB messages.  It is therefore more
>   robust than Classical PMTUD.  This has become the recommended
>   approach for implementing discovery of the PMTU [BCP145].
> 
>   It uses a general strategy in which the PL sends probe packets to
>   search for the largest size of unfragmented datagram that can be sent
>   over a network path.  Probe packets are sent to explore using a
>   larger packet size.  If a probe packet is successfully delivered (as
>   determined by the PL), then the PLPMTU is raised to the size of the
>   successful probe.  If a black hole is detected (e.g., where packets
>   of size PLPMTU are consistently not received), the method reduces the
>   PLPMTU.

Thanks Xin!

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
