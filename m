Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1963163470
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 22:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgBRVLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 16:11:40 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35925 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgBRVLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 16:11:40 -0500
Received: by mail-ot1-f66.google.com with SMTP id j20so21004981otq.3;
        Tue, 18 Feb 2020 13:11:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VF+9+FNI4E+Nip5+V6ijEpNvKUP4upuNUFTZZUsRCXg=;
        b=ETmDyBQgdFxE+CzThVrH7bKsR3aHm3IdXSdhFT+8Px9cad/jN4LsKMmGPQWqVTf6gk
         um3xP1rVIGVQjRS1+yitl99MffVU3EAGCs/XjN2lHE1QLs5+eL6Be670Irvy20rDnhYJ
         BBrfssXVFKYm2H0PWVVtiIUJ4qiVALFtBNGt/Zq2TuUGrHXLSWnpHcshLuE5V3tIU67Z
         pi/c5ACBqcWckdVpNan0WKa6B0sFIP0C9gIVM5jAWXiEkH1hde9xfGrOxIp3/+CxCKg2
         6Mjg+ULMQC0rSpb/WFj++KjJZe+64x+Ky9D5PPaQemY3DGyzQQawWwlA6ORaxJmTFbYI
         819w==
X-Gm-Message-State: APjAAAWERIzDwy4yrnEcCrEdBQAnFFLBIsAtonfZzId0TEoVB0CgVZj4
        6gX404SiV5pjCpSobYgHaA==
X-Google-Smtp-Source: APXvYqwJzVO7Tt+nwt33yTfdT7FBGZHp27tmMJKxVMqskFLak+pv0Qur7ZcoIPtKeYrxDLetf1E5GQ==
X-Received: by 2002:a05:6830:138b:: with SMTP id d11mr16239453otq.38.1582060299527;
        Tue, 18 Feb 2020 13:11:39 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id r10sm1732782otn.37.2020.02.18.13.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 13:11:38 -0800 (PST)
Received: (nullmailer pid 12310 invoked by uid 1000);
        Tue, 18 Feb 2020 21:11:38 -0000
Date:   Tue, 18 Feb 2020 15:11:38 -0600
From:   Rob Herring <robh@kernel.org>
To:     Benjamin Gaignard <benjamin.gaignard@st.com>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, sriram.dash@samsung.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: Re: [PATCH v4 2/2] dt-bindings: net: can: Convert M_CAN to
 json-schema
Message-ID: <20200218211138.GA12217@bogus>
References: <20200207100306.20997-1-benjamin.gaignard@st.com>
 <20200207100306.20997-3-benjamin.gaignard@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207100306.20997-3-benjamin.gaignard@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Feb 2020 11:03:06 +0100, Benjamin Gaignard wrote:
> Convert M_CAN bindings to json-schema
> 
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
> ---
> version 4:
> - remove useless ref to can-transceiver.yaml
> 
> version 3:
> - move can-transceive node into bosch,m_can.yaml bindings
>  .../devicetree/bindings/net/can/bosch,m_can.yaml   | 144 +++++++++++++++++++++
>  .../devicetree/bindings/net/can/m_can.txt          |  75 -----------
>  2 files changed, 144 insertions(+), 75 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/can/m_can.txt
> 

Applied, thanks.

Rob
