Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBDCF0DDC
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 05:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731214AbfKFEh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 23:37:28 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45828 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729774AbfKFEh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 23:37:28 -0500
Received: by mail-oi1-f193.google.com with SMTP id k2so19768268oij.12;
        Tue, 05 Nov 2019 20:37:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wBkgFIR6Kddj9nLfsLZP7ND3JlvDRFLlyjJtifLy8TY=;
        b=qnGrByb6CU5RcV626fRGyQ8wuCA+lSHKhHTP6ye5mjEdJRGmeOb5RbXNRWOch2bBK8
         AiZh1CNhmBzypGJBRkWm/tRUBo+9ajiNlagdsdVS+8evnbV2VlZRiVXf7d+2rLXTnSDP
         XHBFpXSOU3GWU1cHGyUeunCUP5lTBmDk9vNj3yqafafG78DTW7RL+6xl7zHtLci7cOEL
         0cS+BDtbeOntglXeRF91jW0znL3Q0Lx/LJoiIbe8ChU6Sgry3v6VuG552Dl60PhLVhPV
         eXVu74dy9BypcOg3AeDubVOzKWoiNRhIsRzbY5eg8iwr3YKPpV0LyqJouqaeM5Yj1i6O
         PqaQ==
X-Gm-Message-State: APjAAAU7k+tYSJOHjhzteAHUwpwLfDkB/8O4mhwAaEwn01PjDQqdHwYe
        j2tQ5M2aJ+kHZpCgYZh/Ra5TLEE=
X-Google-Smtp-Source: APXvYqy90LJVrIuahwIy0VRpgub2GkHXZqwsDU+WNaRy7fXQpKonC/mLfrcj46KU5AazjL9lDKIFZA==
X-Received: by 2002:a54:4484:: with SMTP id v4mr489884oiv.49.1573015046949;
        Tue, 05 Nov 2019 20:37:26 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id s66sm6861328otb.65.2019.11.05.20.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 20:37:26 -0800 (PST)
Date:   Tue, 5 Nov 2019 22:37:25 -0600
From:   Rob Herring <robh@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: Re: [PATCH 2/5] dt-bindings: net: phy: Add support for AT803X
Message-ID: <20191106043725.GA22549@bogus>
References: <20191102011351.6467-1-michael@walle.cc>
 <20191102011351.6467-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191102011351.6467-3-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  2 Nov 2019 02:13:48 +0100, Michael Walle wrote:
> Document the Atheros AR803x PHY bindings.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  .../devicetree/bindings/net/qca,ar803x.yaml   | 111 ++++++++++++++++++
>  MAINTAINERS                                   |   2 +
>  include/dt-bindings/net/qca-ar803x.h          |  13 ++
>  3 files changed, 126 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qca,ar803x.yaml
>  create mode 100644 include/dt-bindings/net/qca-ar803x.h
> 

Reviewed-by: Rob Herring <robh@kernel.org>
