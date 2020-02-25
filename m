Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5791316F245
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 22:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgBYVye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 16:54:34 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37720 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgBYVye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 16:54:34 -0500
Received: by mail-pf1-f194.google.com with SMTP id p14so287688pfn.4
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 13:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=KcdHvGM7QxFXjBI6YkGaxSLjQS65LiqMdGvAY4ntlYg=;
        b=BJg/VXcEzVPAtNCiJSv2Hc7W1Mt/dRRojyKCXS6TU/oze3/dcR8LqHlcCwGk2hYCL0
         EnSx5OIdw3WVRhLgivB6JzI2dUttE7TLCrw1izn/sjGVTuhOr1hqa0KwTRaWPZG3MDLR
         fRzSE2Ofg7v/iMufnm5emtYziWFDAlaEjdb4a+Vy2yhIR+BqV4Q3AnfDxUK5FgPJwiKW
         nzQRDUTKfxm4XhYnCttB2qASK3jw/jk35JMmrrugzA2i9MHc1K3RFyg/3iQV/Xgd3Er1
         6uNvDED+t5CfC9IPaxWyMZTmTBWyUqHcL39cU7EBxVGFxpYf22o7J/S4gGv0W2tTOkmZ
         cdMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=KcdHvGM7QxFXjBI6YkGaxSLjQS65LiqMdGvAY4ntlYg=;
        b=dHp/FLdaAPQAUXNKtVNSIok58QNo1laMSrjBXmFXL2rhO9P/k/1X8LOFlf3CHckqMi
         UG7Qo9v1K1OYK5mxZHn5g2iPmdPsrdHvDaM6UvhLQc3hQNVXlHB9jCDgCEo81OG/Vpm9
         OBHWjqdZT1b+qX2sBuYcaRxVlMAZtN0Ah68WmOwhmnsT8nI2fTEaGy9jDKZnGtG8oWVo
         m8rzMkyA2quTUAvXqSlqOwJU4hQte+Dbx1vgHbRpij1t7Zk47SVqzGsCt+aSJP5eYSxz
         Pl0sWJ4LL6keW+DfGOXrYrhTXwpL9u9hfy2ZbBDmN9dgX8nfKdgySmJacn95n4L7v5UA
         asPA==
X-Gm-Message-State: APjAAAUvT707t311B13exQxqc+Got2GUkB9lhI26F+CBN4apln1xBmt+
        VTNt0PexmHJ+pl17ugDRCcE=
X-Google-Smtp-Source: APXvYqzXeuEPfSp3VdcIUBjDS39ldgr3ryfWOcsFqMbnkGtbJXYVP3g74RBwe0bGHjwpABjKCvaYog==
X-Received: by 2002:aa7:9546:: with SMTP id w6mr816916pfq.66.1582667672366;
        Tue, 25 Feb 2020 13:54:32 -0800 (PST)
Received: from [172.20.102.201] ([2620:10d:c090:400::5:1dea])
        by smtp.gmail.com with ESMTPSA id w81sm48493pff.95.2020.02.25.13.54.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Feb 2020 13:54:31 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "David Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        kernel-team@fb.com, kuba@kernel.org
Subject: Re: [PATCH] bnxt_en: add newline to netdev_*() format strings
Date:   Tue, 25 Feb 2020 13:54:30 -0800
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <CDA6E3B5-FB0A-4092-8F2B-44BD4357C633@gmail.com>
In-Reply-To: <20200225.114544.1730081330061687105.davem@davemloft.net>
References: <20200224232909.2311486-1-jonathan.lemon@gmail.com>
 <20200224.153254.1115312677901381309.davem@davemloft.net>
 <0C3291B2-E552-420F-B31F-F18C6F5FE056@gmail.com>
 <20200225.114544.1730081330061687105.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; markup=markdown
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25 Feb 2020, at 11:45, David Miller wrote:

> From: "Jonathan Lemon" <jonathan.lemon@gmail.com>
> Date: Tue, 25 Feb 2020 08:16:35 -0800
>
>> There should be a single posting on the list, are you telling me
>> otherwise?
>
> There were three postings:
>
> https://patchwork.ozlabs.org/patch/1243698/
> https://patchwork.ozlabs.org/patch/1243701/
> https://patchwork.ozlabs.org/patch/1243702/

From the headers on the first one, that should not have
gone out; the second was the correction/check, and the
third was the actual posting.  I'll add some scripts to
automate this for next time.

Sorry about the noise.
-- 
Jonathan

