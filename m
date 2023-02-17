Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA9369A82F
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 10:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjBQJeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 04:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjBQJef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 04:34:35 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BDF4B507;
        Fri, 17 Feb 2023 01:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=dAG0MK9QuyqXyIBrU7Pb7kuHuG8r9p38rLl/zqDJsRo=;
        t=1676626475; x=1677836075; b=XiPEYS/a2VUK+99Bci4aX/jOPAJcmKmvSaqjWWvW9T1XKNx
        9nx8vaG+O+lQRNOYTmbJl+mv9pLklT4MRHtF73bUoapFuVRouq6OmrjIhvIvxj9G8WLsjl+N7Gaq0
        L09SyJ/fvx081c0VnHzvBUW0tOGhO8DuasPdmBULiWLrCJtWxZvg/QAsyC2/KfZ6qpIGWvf+TGvwD
        HSn/XpmV03rYJrzW3nknIVROueuJGuD5HQFiR/e05j/DyKlo+vWBUBCCa5TWFmgLtl+tj2JsOKqqi
        hO4Gr4PhXb70tzlXMOf39nYKFyVAqB7AmCG97/w2yt6JZ+10ob3z618KRYeHt+Mw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pSx8T-00ExEs-1Q;
        Fri, 17 Feb 2023 10:34:33 +0100
Message-ID: <a117074810ef2c15ba3fa5fb60db2f5927e736eb.camel@sipsolutions.net>
Subject: Re: [PATCH v7 1/4] mac80211_hwsim: add PMSR capability support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jaewan Kim <jaewan@google.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Date:   Fri, 17 Feb 2023 10:34:32 +0100
In-Reply-To: <Y+9JXU+5QEU1TMdi@kroah.com>
References: <20230207085400.2232544-1-jaewan@google.com>
         <20230207085400.2232544-2-jaewan@google.com>
         <6ad6708b124b50ff9ea64771b31d09e9168bfa17.camel@sipsolutions.net>
         <CABZjns42zm8Xi-BU0pvT3edNHuJZoh-xshgUk3Oc=nMbxbiY8w@mail.gmail.com>
         <Y+8wHsznYorBS95n@kroah.com>
         <e98a38890bb680c21a6d51c8a03589d1481b4e29.camel@sipsolutions.net>
         <Y+9JXU+5QEU1TMdi@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-02-17 at 10:31 +0100, Greg KH wrote:
> On Fri, Feb 17, 2023 at 10:13:08AM +0100, Johannes Berg wrote:
> > On Fri, 2023-02-17 at 08:43 +0100, Greg KH wrote:
> > > On Fri, Feb 17, 2023 at 02:11:38PM +0900, Jaewan Kim wrote:
> > > > BTW,  can I expect you to review my changes for further patchsets?
> > > > I sometimes get conflicting opinions (e.g. line limits)
> > >=20
> > > Sorry, I was the one that said "you can use 100 columns", if that's n=
ot
> > > ok in the networking subsystem yet, that was my fault as it's been th=
at
> > > way in other parts of the kernel tree for a while.
> > >=20
> >=20
> > Hah. Maybe that's my mistake then, I was still at "use 80 columns where
> > it's simple, and more if it would look worse" ...
>=20
> It was changed back in 2020:
>  bdc48fa11e46 ("checkpatch/coding-style: deprecate 80-column warning")
>=20
> seems to take a while to propagate out to all the subsystems :)

Ah no, I was aware of that, but I guess we interpret this bit
differently:

+Statements longer than 80 columns should be broken into sensible chunks,
+unless exceeding 80 columns significantly increases readability and does
+not hide information.


Here, I would've said something like:

+	if (request->request_lci && nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_R=
EQUEST_LCI))
+		return -ENOBUFS;

can indeed "be broken into sensible chunks, unless ..."

Just like this one already did:

+	if (request->request_civicloc &&
+	    nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC))
+		return -ENOBUFS;


Personally I think the latter is easier to read because scanning the
long line for the logical break at "&&" is harder for me, but YMMV.

johannes

