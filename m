Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2968E564F21
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 09:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiGDHyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 03:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiGDHyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 03:54:44 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81619FE2;
        Mon,  4 Jul 2022 00:54:43 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l40-20020a05600c1d2800b003a18adff308so5149061wms.5;
        Mon, 04 Jul 2022 00:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kBt8UkN3aWCTiSF8Lh8xZQRr6v5h00YtDHTaqSFljec=;
        b=cC7gFTPZu/aPJz87RZe/z5TpXDPurO2A6Cb/+oswtY3Sx2RhvcCJBPKJ/+T2UF17J1
         RBMUfv1aH45VHiF5kxJprtroCBFRVGeGdSdeApWbVy7NJryexftlPSVOR+aZTfDNcScP
         FL0egZZgY9fTZaAka+QZ/S6AwirONIg1sycBSUdTAVi18Q/q4ojoXEPnCuJbE6UOJJsd
         okRmwOIlFkHHVuCSV0qwt1rdwRwk1JEuTgJsazs3DSjIfZxNyZCcCcLBTC/ISt8Fcioc
         r+YKMeRKDYfSIV0PCSYSlUYta8wsU8jgiqsefwiPxfIpGzd1FocS4pOAW3vC0jxUtQNJ
         KSQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kBt8UkN3aWCTiSF8Lh8xZQRr6v5h00YtDHTaqSFljec=;
        b=zYKCGTUe9fuX1dBg2ASlxG9Wc28uKhB9one4nh0tAe8Gi+4o8Hv2XgiiF9b1SlLhv2
         pE3eE2/q54ZXVg+Nv5lwiKhCL2Dz0bIic+CRNvlq9r+lmfxyA9qQr1FXIPveAUTEHRcX
         A1dYzORZccRUTzhjXqa7nDjQo7qmCqvG8rIhJ9NhpKcRJPybJyNuStfMIuVpSieuEDsf
         4OH521iBKdrP6/T70c7q7nN2jab42GzCA3sD//dbeVVRZURGmk/nwZKnwzA7byVzjMD7
         gIXoG2tdbpVV9c+hv2xdbJ+wqw8bGfVn+q30NHHScsDg38+5ovH64XnNUtf9xTugPKxn
         WLgQ==
X-Gm-Message-State: AJIora+5RZtAPoBfRz2ISSwy8rAn64w0DcNHRzHtZXUnuGwAXeDZVYAm
        CBMFb57SLnH38q6o7YWgKX8BoMMfMWzMGd8UzrA=
X-Google-Smtp-Source: AGRyM1tbwq5EsVddzD4ybXz0zJM+EtGcKfP76YCqwP4/9Q5UwkGkjPekVIXrT0y3XzQLeRWbRQnkzHnvn1Gwxl91xVU=
X-Received: by 2002:a05:600c:4f81:b0:3a1:a8e7:235b with SMTP id
 n1-20020a05600c4f8100b003a1a8e7235bmr4385163wmq.149.1656921282262; Mon, 04
 Jul 2022 00:54:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220630111634.610320-1-hans@kapio-technology.com>
 <Yr2LFI1dx6Oc7QBo@shredder> <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder> <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
 <Yr8oPba83rpJE3GV@shredder> <CAKUejP4_05E0hfFp-ceXLgPuid=MwrAoHyQ-nYE3qx3Tisb4uA@mail.gmail.com>
 <YsE+hreRa0REAG3g@shredder>
In-Reply-To: <YsE+hreRa0REAG3g@shredder>
From:   Hans S <schultz.hans@gmail.com>
Date:   Mon, 4 Jul 2022 09:54:31 +0200
Message-ID: <CAKUejP4H4yKu6LaLUUUWypt7EPuYDK-5UdUDHPF8F2U5hGnzOQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: bridge: ensure that link-local
 traffic cannot unlock a locked port
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> IIUC, with mv88e6xxx, when the port is locked and learning is disabled:
>
> 1. You do not get miss violation interrupts. Meaning, you can't report
> 'locked' entries to the bridge driver.
>
> 2. You do not get aged-out interrupts. Meaning, you can't tell the
> bridge driver to remove aged-out entries.
>
> My point is that this should happen regardless if learning is enabled on
> the bridge driver or not. Just make sure it is always enabled in
> mv88e6xxx when the port is locked. Learning in the bridge driver itself
> can be off, thereby eliminating the need to disable learning from
> link-local packets.

So you suggest that we enable learning in the driver when locking the
port and document that learning should be turned off from user space
before locking the port?
