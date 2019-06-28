Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A825A109
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfF1Qfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:35:36 -0400
Received: from mail-lf1-f53.google.com ([209.85.167.53]:35301 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbfF1Qfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 12:35:36 -0400
Received: by mail-lf1-f53.google.com with SMTP id a25so4393148lfg.2
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 09:35:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=nwVfPs+vIRBiktClscrgxMmqQM1hwDrGpHuR2rGCVDY=;
        b=JhSlc5CwdXusuV1a9yss+OEoegTe2Y9xHVKyGztUbCmG7mpiDI+ne6g80d9u4WHGXh
         jHfxHxuB4Sj4Q2JPWIpUiw1Z785pVXy+Bv/nITV02BCWAnp7SvCMRJSNaplEgNgEoWdg
         O46CUx+E/ohdtlOsFHsDBAYKQFa2UuVuy0aAWYOBf1phgidVCPVG8HT7h3hDZV4jvbdx
         oeQdEMYd3W/LE42Ihk/bHO//NXF5NeizuISt00UoDfQCbh8jHNBazsN/ShNmfYMatH7T
         pmbvb8n8a3lWwpJqWL/0PJJAxedRnS+Dnql0H0ex85uDMWhIoY9aM4oLuw3x68+t65la
         FBrw==
X-Gm-Message-State: APjAAAWP2wOM7jirlfEWexU0w5QldIIYZ3zBDZGZttid+bkad4wM2ezp
        UN+qL4NNjsHrR2mV81Af0w9lFCmoYBQ3CwiwjysL1jISOIw83w==
X-Google-Smtp-Source: APXvYqzJTO1posPWsyifEBPmyg1q49r/NpZ6fZUXRp3qxp05xvQunGF0v2b0fJs5viNlmGejRJivqSb/XkLwXVI68Qc=
X-Received: by 2002:ac2:5a01:: with SMTP id q1mr5546835lfn.46.1561739734447;
 Fri, 28 Jun 2019 09:35:34 -0700 (PDT)
MIME-Version: 1.0
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 28 Jun 2019 18:34:58 +0200
Message-ID: <CAGnkfhxxw9keiNj_Qm=2GBYpY38HAq28cOROMRqXfbqq8wNbWQ@mail.gmail.com>
Subject: net: check before dereferencing netdev_ops during busy poll
To:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Elsasser <jelsasser@appneta.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Is there any reason for this panic fix not being applied in stable?

https://lore.kernel.org/netdev/20180313053248.13654-1-jelsasser@appneta.com/T/

It seems that linux 4.9.184 has the bug too.

Regards,
-- 
Matteo Croce
per aspera ad upstream
