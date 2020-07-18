Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECEFF2249D5
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 10:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgGRIbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 04:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbgGRIbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 04:31:25 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7002DC0619D2;
        Sat, 18 Jul 2020 01:31:25 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id e8so7783457pgc.5;
        Sat, 18 Jul 2020 01:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=IJ6earoqykCVt6o3J28TqfvGcx0vADiIhfi51y4OCk4=;
        b=gAFx9lfW47pIUPWLtcThE9MAfGBIkByT1JeFmZdlfSx3HzSFnYUupAGiPpacLQM2L4
         X6Q5Tc9mtUG56h1fquzpy/upr0oIbVSjNRW7SBj29o5vBzWn7TpLMZfDu8JjXYgRE/1J
         kEqaTIaps1K6/HyWZ9WFyqQejVef5HCFfyBpQKUCnw3LCU1xGYQp8kNvmitXw0+AhJCp
         YKGw3ESUKBeF8O22cxiWk/MrGapbQArZLU5IzIQo677QxnBdyPk26qmQ64rP0Kihg9J7
         jiQvQx86FLlDdJCAJtmdhTN9xHQQkQl4s4SsVh4KGw2GQyOG3npZKbCkhm3bz7oUyBFT
         uZqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=IJ6earoqykCVt6o3J28TqfvGcx0vADiIhfi51y4OCk4=;
        b=eNzAZWPGgdBa1x+Hk+qjkLhm9vpgmSNzFI7/aFdyBZo00lM1sqhe2igcIevB/wThmY
         EDDy9wubCNHZTqj3XP0O9NSB7M5/ql64I0fyrOLc7JuavwyWAEOZprVI83BORGqkJE84
         djjxvJVtoTnSuoAWg+GceKGu3qsWSk2n1dwVPSCEFcqi4Yt6fP4E1jlAkldMMAGrhQs5
         lwjznZIEKyNEQ4X4ujBh3OiqYSUWNBbgkswR3/yRUiaBevSS91eaNJeyhoDdHN6eecfZ
         71qYxRrim51jUqcuoJ90TZM7aP+5HKKJvQfsetrmsdFFWbxtbTUWS6mJ8XAtS0Up1ITa
         WNJA==
X-Gm-Message-State: AOAM533xOKpAqn3iC0jDlPeBmtmGoVrfSOlePtddN8Su9zRR+F3aaXYp
        mHAQocj9KDc8gQijXP3GRUPRSwtDQP4=
X-Google-Smtp-Source: ABdhPJzGKMQogFaHht6SdiKigrGPtZFXg0HVQ/V9AzI9QJx95FP0JqxF4z2OqYz04JKups1XRnQ/+A==
X-Received: by 2002:a05:6a00:1589:: with SMTP id u9mr11609373pfk.201.1595061084952;
        Sat, 18 Jul 2020 01:31:24 -0700 (PDT)
Received: from blackclown ([103.88.82.25])
        by smtp.gmail.com with ESMTPSA id k2sm9444641pgm.11.2020.07.18.01.31.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 18 Jul 2020 01:31:23 -0700 (PDT)
Date:   Sat, 18 Jul 2020 14:01:01 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND] net: decnet: TODO Items
Message-ID: <20200718083101.GA26780@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Maintainers and Developers,
	I am interested in the DECnet TODO list.
I just need a quick response whether they are worth doing or not
for the amount of development happening in this subsystem is extremely
low and I can't help but question whether I should indulge in any of
the listed works or not.

Thanks,

Suraj Upadhyay.


--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8SszsACgkQ+gRsbIfe
744LkxAArVPXt/aVg9CGW6jw9tZvXLJB6kCitq+ZFDE3m77Jicj/hpyXFXA2axll
yyGpLPkmfp9ipYsqaZph3mL1m6d2paAcl/hxK+lNfOFNuc8MyCIh+jMSub9Wf2VW
Bgjn4TOn5LQW8DqCN/Avxa1kh1hDj9K48q/KdH9LhoAjowz08UTI1ed/ZNcERhwu
tHxX1EiLkbpnwueSZ7ljrB9bBEMQ7pEHmilB7ALLTiRN035Ugj3+PWI2zhYShe4T
usCQv0tbhcllW6y9U9jAMAbBp/PlL86ti5RpeybdP1CbbS7EalhQ0lKA+/FxAmFP
+uNaDVuI9KobwgNchNmZu095PxoAtyA61gWP2xAQsxmQGGbI2+MkTHVPy+wLmRnh
vTS/gTPzKe5LPmJ9eYZwWIykTNkpBzBOaslXbdD+IlDwFEYd2UWYrKUJz/piB/hj
5GQuiqbm68wHrFi/2zip1jOhfmRtkHKcIpQuOEkkmTWLlLc/TcMfAQzcnzDTZS59
eC+bQiDrops+Y9EimXhXwIPnie1LvYiOvFiXlycTijZPkZBesPtbLk7mZgDsG4B9
vVcclgAVqjCaNtJz9IlMINy5DA3sqAgUJd0QKRkFQhT5sMYWzR65EfjCxEN4058D
Mehg4WNHsiVBoGV4ros2HJucgiAtiDX42QSmFpKBqOSU//Dwomo=
=QZhb
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
