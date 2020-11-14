Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78012B2C9B
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 11:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgKNKI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 05:08:26 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54793 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgKNKIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 05:08:25 -0500
Received: by mail-wm1-f66.google.com with SMTP id d142so17604330wmd.4
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 02:08:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zqq3KXsbCh+A4XRGesodQomUE1KKi9x/4shZXgvPuFo=;
        b=a72+4+0fGiCwDin/qO+l0SdEwdQoDSZ0xR+qnb9Uh0WDKQjKJUpQdih7VF3yAIZUNP
         w5c2ss9thULaWzGBiri8lpUCbciksKYJmr7g/y+QjwxtnQbFVfMIJJ3xu3uOx72gGFvv
         9Nr8tj6ext/y+4xksXg79MZAjQGW+MZmkHAd/0SMDNhPplIVkuKUc5AYnObx+FEcS+Pb
         B4Y/sZZOk8PFdHXjsaYhHimYVuY++ULeoKwAxpu5C0yVUilunGiCRu+8ouoPyx2J9uta
         PwRJt8JvBNbUB2R3TN2eiyyBseLgi+fw8ePQrVkz25I+YrfhQC51PROjjPdIAitrlrLd
         322A==
X-Gm-Message-State: AOAM533DfEl72op0sV0lcEdMoXhwkWbGozv5rMQOk7opM8SouTXF7lg9
        XdO/LNdjZjMbXDy9JFGnOQ+vw/bBU2hf4w==
X-Google-Smtp-Source: ABdhPJxfEEuDMCsna/h3dx3N/aX81InmGohN8v1KaLK8jcUvYVOzo+WywJvwZswvf6Xjpzy2ES0Hjw==
X-Received: by 2002:a1c:1d09:: with SMTP id d9mr263994wmd.93.1605348503598;
        Sat, 14 Nov 2020 02:08:23 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id a18sm7286541wme.18.2020.11.14.02.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 02:08:22 -0800 (PST)
Date:   Sat, 14 Nov 2020 11:08:21 +0100
From:   "krzk@kernel.org" <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] nfc: s3fwrn5: Change the error code.
Message-ID: <20201114100821.GC5253@kozik-lap>
References: <CGME20201114002134epcms2p1b504111777f3b1be7a0d1706882a5237@epcms2p1>
 <20201114002134epcms2p1b504111777f3b1be7a0d1706882a5237@epcms2p1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201114002134epcms2p1b504111777f3b1be7a0d1706882a5237@epcms2p1>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 09:21:34AM +0900, Bongsu Jeon wrote:
> 
> ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP.

The same as in patch #1 - trailing dot a subject end empty line at
beginning of commit.

Please CC all required maintainers and lists when submitting patches.
You skipped here LKML and the most important - NFC mailing list. Use the
scripts/get_maintainer.pl to get the necessary addresses.

Best regards,
Krzysztof
