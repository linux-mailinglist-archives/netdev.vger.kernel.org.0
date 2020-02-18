Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 064CA16346A
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 22:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgBRVL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 16:11:26 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42916 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgBRVL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 16:11:26 -0500
Received: by mail-ot1-f67.google.com with SMTP id 66so20978837otd.9;
        Tue, 18 Feb 2020 13:11:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JLj5MuG39X7ohvdGwz68k7hpK4bGkAF6LlKwMzI17fY=;
        b=cG+CeNo49EJxj5IVLB7T4jroy16d3Cban2zFWV9nUD651ikmNVaMbV7HS5m/Rhq8pt
         S8jAyrdpEKFMAEPEEAb8DxQxcAjC7VFw7kNQnW/vzBwSH/NAssvuAI3J27LtFMorxJGo
         eEhY7cH/GKN37PakbdBl5SLnSAwZRL0aZjq3XqlzCTQJJkOwcRv7ICXRuRJCRCVZYdIV
         8FaiYMHw68pXWg63uoHbZ9+Jgihn/EOzwXvnxi7zJ2NupHGSydXcwOURas9C7Bcmi6i5
         rUOGa7toDOOxj58qbZnk4U+0M7TBALKFw+2KCzb9+C2FKQQxQUhzXyp5aNA9h/JTnscO
         FFjw==
X-Gm-Message-State: APjAAAUZjtusudsDD8RmtPy2iamt52T8xG8LZCM4YzRNP2s1xC3H2hly
        PgbZ4HEGb7QeWVTqTAvErg==
X-Google-Smtp-Source: APXvYqyvDWo4AalFirW/wiyW+z0rlSsdM7ILddVe9R02+u1l0aKDD+QFfJX6c1Cxuf/5hwFswmpkPg==
X-Received: by 2002:a9d:4f02:: with SMTP id d2mr2472350otl.368.1582060285321;
        Tue, 18 Feb 2020 13:11:25 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id p83sm3813oia.51.2020.02.18.13.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 13:11:24 -0800 (PST)
Received: (nullmailer pid 11759 invoked by uid 1000);
        Tue, 18 Feb 2020 21:11:23 -0000
Date:   Tue, 18 Feb 2020 15:11:23 -0600
From:   Rob Herring <robh@kernel.org>
To:     Benjamin Gaignard <benjamin.gaignard@st.com>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, sriram.dash@samsung.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: Re: [PATCH v4 1/2] dt-bindinsg: net: can: Convert can-transceiver to
 json-schema
Message-ID: <20200218211123.GA11668@bogus>
References: <20200207100306.20997-1-benjamin.gaignard@st.com>
 <20200207100306.20997-2-benjamin.gaignard@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207100306.20997-2-benjamin.gaignard@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Feb 2020 11:03:05 +0100, Benjamin Gaignard wrote:
> Convert can-transceiver property to json-schema
> 
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
> ---
> version 4:
> - no change
> 
> version 3:
> - only declare max-bitrate property in can-transceiver.yaml
> 
>  .../bindings/net/can/can-transceiver.txt           | 24 ----------------------
>  .../bindings/net/can/can-transceiver.yaml          | 18 ++++++++++++++++
>  2 files changed, 18 insertions(+), 24 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/can/can-transceiver.txt
>  create mode 100644 Documentation/devicetree/bindings/net/can/can-transceiver.yaml
> 

Applied, thanks.

Rob
