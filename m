Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38DC312DF4F
	for <lists+netdev@lfdr.de>; Wed,  1 Jan 2020 16:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgAAPn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jan 2020 10:43:58 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39848 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgAAPn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jan 2020 10:43:58 -0500
Received: by mail-pj1-f67.google.com with SMTP id t101so2285986pjb.4;
        Wed, 01 Jan 2020 07:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VdaVqR2ujWwMtU+rRnAVHf5ttw+w7rhJxthTZ3o7ZdQ=;
        b=pXz7cfi3EsWcEnPF2R7r6XUehvtBhb8oLqgYGXM1qmty3/xRgtWPNrc5iwQrvGuzcp
         gll7CuU2fOve7A+HNTtB/hbvtIu9nig7s63HSFlNa2q0D+DitiPXWnCaTg7dnQT/C8MQ
         0MzjFuvTfkH5zZl7gg7XmX1O8KUQOVKi6bWSPDlQcltdo3ZSClqYmMDSW4H4msFN2o+B
         5AtFu3lm4XiD7hlmgtVx0T/exmkZ+I19+AsSqLt4dqwNQPdujDRkdyejxZ1Bs0QnuLzJ
         Ys3haTm0PUQsjoxGWGCjgOFOWE0QvmHo2NEm1kUBTQ1jHpbPMpWyeSXFLAg3O5BmnFWz
         kk2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VdaVqR2ujWwMtU+rRnAVHf5ttw+w7rhJxthTZ3o7ZdQ=;
        b=SBWj9rWEsHi+M9KBu3jCZFI02GbuCJ7Ms/OFDnyy7DEfzyrT1+tAAcIxBdWIDARrIs
         AAih8tn12NoMdcrvOX9f3WlAO86sF/GLn0WtCE+x3/yTeuPh098tS511SkU25PF5iEKZ
         Qx46Z8yR+UtTgMEMo3RKcLDa+LYrGfBCDBgYudX5Mx0+79LUKTNhAaf0QhN5YIPMRQ2v
         WrhTwIXW+wHYxjJO3NvPWiH3D3F167/l9X0PjCu8wiM6kYB26+wHVEhxbniZUvk874pR
         VQcTOTmE1qo9ZyExS3+X/1ys2lZkbgpsrxHtRjnKiOPaxY7ojCgVQrNYMEDlFzsPIq7D
         e5kg==
X-Gm-Message-State: APjAAAVNP0Su31Pgh2DMY1gx6cxBzURWr6IwPeayRD0p9WWFoYHT2wd7
        t/mKwG3W+j9oqhvUDN6VMzQ=
X-Google-Smtp-Source: APXvYqxy864mqKVWWZVzvp8LHO7Vz1nEwOFv5RJYWjdi22BGg2ETNlOr2YHhBAtNvgUjlvjdpJ4d8Q==
X-Received: by 2002:a17:902:8f97:: with SMTP id z23mr80638474plo.170.1577893437376;
        Wed, 01 Jan 2020 07:43:57 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id m6sm7589154pjv.23.2020.01.01.07.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 07:43:56 -0800 (PST)
Date:   Wed, 1 Jan 2020 07:43:54 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/16] ptp: ptp_clockmatrix: constify copied structure
Message-ID: <20200101154354.GA1524@localhost>
References: <1577864614-5543-1-git-send-email-Julia.Lawall@inria.fr>
 <1577864614-5543-14-git-send-email-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1577864614-5543-14-git-send-email-Julia.Lawall@inria.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 01, 2020 at 08:43:31AM +0100, Julia Lawall wrote:
> The idtcm_caps structure is only copied into another structure,
> so make it const.
> 
> The opportunity for this change was found using Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

Acked-by: Richard Cochran <richardcochran@gmail.com>
