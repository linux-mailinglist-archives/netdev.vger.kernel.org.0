Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC2B2B0FF9
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 15:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732194AbfILNbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 09:31:13 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:42927 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732128AbfILNbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 09:31:12 -0400
Received: by mail-vs1-f67.google.com with SMTP id m22so16160730vsl.9
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 06:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=WD/3elM55KkXxavtAW8hn0Fju2GCWv2usA5rijE2lR0=;
        b=mux7lnlIS7VWhNRtfW1lAzsh1N3CSsyvkLJ/rtZXHKftGBCRAu6+LqSgR53TOPAICQ
         eoYfrOhfZQLrdyXdsEu4E3X9N3nnXmujIPcrE1PtTz26OF/HlOxXWctvFH6aOhmsFXGv
         Il6QvhEBzMfpKVfotuWCkzWzZ86ZAy1JwptIsAs75CcmUE7eBqpqO4QjatYN/2VYfTLP
         muppXMUdb7ONfN0uZ7bL1wu/oEyC5O6VaQGqNzDJxVPY8WhYszXZi17S6Uz46PlHnZUJ
         k5udQz+WZ1c44UKEPRXKTTZdxEmZGWVlE/R0FJvIuU+fzTIXi3tLYgVbrFFCUTMfIR3e
         Fojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=WD/3elM55KkXxavtAW8hn0Fju2GCWv2usA5rijE2lR0=;
        b=fODCR/lpTZdMTYKAbvjLEIbyHwAxJnPzlBEtvOXzQEZYKc5pMVXLIShPnhnXPkl9Fc
         kKhN4bm4hpyyEm7tBkwHKuCildFqESv6YFQwO5qAXLHvdRnoGFm2bSUG8ujoNWFue7qx
         0kM+W2aCQ7PfJiz2GNlvw5hOeCAarsRCUg0mGCq87JJEJSV/howVAzo7IrR90oorDPmL
         9zfGpVimNKRzsVxGTZTe7P+O35kBWUCWOBuNeOp6djnaqS8/GRcuw3dejGpFjIQSbeb2
         nzEw6AFxsGlV9st1KLAOxg6UvuGHGH0RHxmTyDK5JCTKufuMlfk1lzT5zIi/5xYWXGqq
         OtHQ==
X-Gm-Message-State: APjAAAVbjPvDgb1ojjTA6IciUqUG0cyPgK10s406BxXbOZLak3V7mzua
        T+uG5QxYxUttmaQnpEgk63ocmH0uCPp1VB+NEWA=
X-Google-Smtp-Source: APXvYqx6Kwg7JDqTa3WS2g73LD/9++XiDg5W1465bxjaUeMqDadnRyQRBcWqRc40584+o8iq0inGrajCVRhfT+XTJBM=
X-Received: by 2002:a67:ebd5:: with SMTP id y21mr21081217vso.70.1568295072076;
 Thu, 12 Sep 2019 06:31:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9f:2c4f:0:0:0:0:0 with HTTP; Thu, 12 Sep 2019 06:31:11
 -0700 (PDT)
Reply-To: rumpfklaus7@gmail.com
From:   Dean <jefferydeannn@gmail.com>
Date:   Thu, 12 Sep 2019 06:31:11 -0700
Message-ID: <CAH_WNogGxG6w0r-u_rNVztn2f0LS1x4xVKBMf4_gUF_ogRReqg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Did you get my proposal ?
