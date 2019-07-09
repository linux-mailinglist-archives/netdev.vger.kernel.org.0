Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C4D63ABD
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 20:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfGISVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 14:21:03 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36113 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfGISVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 14:21:03 -0400
Received: by mail-qk1-f193.google.com with SMTP id g18so16765470qkl.3
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 11:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=VpSrckJWvnQDSNnTi3MOVatPivFskEFiINg4Bqu5/SY=;
        b=KMI40B1TtlYViXa10TN9ds+Y56LK+Oh3kI/PsqrC55Etr60/PlOJgyxYP6vBZRwCmr
         0mQ/qD+gY0jxKz/GL+5/kSLQ0XT4nq5ajlceNrXvy0e+NyEM6DLIwsi9j97mJvz66kUD
         v3YRIQj4qfaAxA0sxAM8rvbVI3F7CKQ96NHydFTbva4reIG0z9ktXwORjj3FXObxPlnC
         1vm+UFLclvJ5YX99BCbPMzVvnT5molZLq6ZzyPDMbSJakqxoxkKyv94LCVZ3HftNg4v5
         /z46HtIzizMH4cMaXlBZuOMQML6RHXX9SBHEsYQbFsEye8FEqSOx+sWkP8wVBiwdmGZ0
         zFVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=VpSrckJWvnQDSNnTi3MOVatPivFskEFiINg4Bqu5/SY=;
        b=KJXHKzdtLlPvCdVEBOvd6VC1cVJkRNf/HmuDPxcz58hKWh/nDJrNSqtg9YTa1bAEdr
         k7mEOoScxauwjpSeDEDZlvSDge8XnSlgVPsB4AXtGO4sgP+QGfa6NokBgp8mNgv4ESTH
         Um8rsV+J3FcK+wlUV2C9ug1v0FNAXz+imbxYkdj/AbzBdy7E3mvhoGnBI3KstVmGb7Ij
         epGgtTNWLnLkxpimkVZujsMlz2iY9jNhImg2r51oK6EgkJTOHMljjpMzttvDug4UpUiH
         fv5CpGtmQtbJRZYb4FZNUfPgGLKFIV1K5cvJ5Rlv5ZfkW/pLpZIOrekyoGmiIZrSeR6X
         AJFg==
X-Gm-Message-State: APjAAAU/BuQ4hUhnyBXX5frjuQfhcVH3snHJo+/TrlI3yhRKhxh8Y+0V
        bxnbMmtxJ2/yKcUIX/HvBjR4+w==
X-Google-Smtp-Source: APXvYqxqsAmI5OZJ7zbyDJKyZ7Bi1A0MYQ4pXvQ5RtmCXlYEetIP92VCwnYDiqqaBsfRPi/AP/0CGw==
X-Received: by 2002:a37:4b58:: with SMTP id y85mr20052505qka.8.1562696462574;
        Tue, 09 Jul 2019 11:21:02 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c82sm8103923qkb.112.2019.07.09.11.21.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 11:21:02 -0700 (PDT)
Date:   Tue, 9 Jul 2019 11:20:58 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Parav Pandit <parav@mellanox.com>, netdev@vger.kernel.org,
        jiri@mellanox.com, saeedm@mellanox.com
Subject: Re: [PATCH net-next v6 0/5] devlink: Introduce PCI PF, VF ports and
 attributes
Message-ID: <20190709112058.7ffe61d3@cakuba.netronome.com>
In-Reply-To: <20190709061711.GH2282@nanopsycho.orion>
References: <20190701122734.18770-1-parav@mellanox.com>
        <20190709041739.44292-1-parav@mellanox.com>
        <20190708224012.0280846c@cakuba.netronome.com>
        <20190709061711.GH2282@nanopsycho.orion>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Jul 2019 08:17:11 +0200, Jiri Pirko wrote:
> >But I'll leave it to Jiri and Dave to decide if its worth a respin :)
> >Functionally I think this is okay.
> 
> I'm happy with the set as it is right now. 

To be clear, I am happy enough as well. Hence the review tag.

> Anyway, if you want your concerns to be addresses, you should write
> them to the appropriate code. This list is hard to follow.

Sorry, I was trying to be concise.

> >Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>  
