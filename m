Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78C758F5CC
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 04:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbiHKCXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 22:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbiHKCXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 22:23:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DA58D3E7;
        Wed, 10 Aug 2022 19:23:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CED8261196;
        Thu, 11 Aug 2022 02:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C337BC433B5;
        Thu, 11 Aug 2022 02:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660184591;
        bh=f5GjtckqzBsBlySN8rj/tgN3qLP8Rw70hcKyiSiodOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=likDCdV4mJli0rvcgJ0Ei0UubgrBp8VlBwcncxsHy4twwIq9tdeVXNwmadZUz2jRD
         S6v/xdpNUKKLxjtHC3GWrviWTnpno3Vqi3p50jVZYUhABO9dSCLvK0fB3xdKV6hmD4
         42fOkFFqlV92xR1NGL7oV4+NFLdV4DsMlCnQJPYZhb92Z+4yjIhEuj/oQ5KhGGvwT2
         ZMidUrcvKHuVsGqMdBRDoAv3VPzWTNb5AUVlP0wov3XEAiobUwPWleQljoXCoVRGeu
         L/LsiSPQi0qiZyIICOm431UGcM3eJIFyC43bmd4Lv6H2m/BCFJKC6sh10YnQfJfVyh
         ybVCCwQd635Kw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Cc:     sdf@google.com, jacob.e.keller@intel.com, vadfed@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de,
        linux-doc@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 1/4] ynl: add intro docs for the concept
Date:   Wed, 10 Aug 2022 19:23:01 -0700
Message-Id: <20220811022304.583300-2-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220811022304.583300-1-kuba@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Short overview of the sections. I presume most people will start
by copy'n'pasting existing schemas rather than studying the docs,
but FWIW...

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/index.rst                    |   1 +
 Documentation/netlink/index.rst            |  13 +++
 Documentation/netlink/netlink-bindings.rst | 104 +++++++++++++++++++++
 3 files changed, 118 insertions(+)
 create mode 100644 Documentation/netlink/index.rst
 create mode 100644 Documentation/netlink/netlink-bindings.rst

diff --git a/Documentation/index.rst b/Documentation/index.rst
index 67036a05b771..130e39c18fe0 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -112,6 +112,7 @@ needed).
    infiniband/index
    leds/index
    netlabel/index
+   netlink/index
    networking/index
    pcmcia/index
    power/index
diff --git a/Documentation/netlink/index.rst b/Documentation/netlink/index.rst
new file mode 100644
index 000000000000..a7f063f31ff3
--- /dev/null
+++ b/Documentation/netlink/index.rst
@@ -0,0 +1,13 @@
+.. SPDX-License-Identifier: BSD-3-Clause
+
+====================
+Netlink API Handbook
+====================
+
+Netlink documentation.
+
+.. toctree::
+   :maxdepth: 2
+
+   netlink-bindings
+
diff --git a/Documentation/netlink/netlink-bindings.rst b/Documentation/netlink/netlink-bindings.rst
new file mode 100644
index 000000000000..af0c069001f3
--- /dev/null
+++ b/Documentation/netlink/netlink-bindings.rst
@@ -0,0 +1,104 @@
+.. SPDX-License-Identifier: BSD-3-Clause
+
+Netlink protocol specifications
+===============================
+
+Netlink protocol specifications are complete, machine readable descriptions of
+genetlink protocols written in YAML. The schema (in ``jsonschema``) can be found
+in the same directory as this documentation file.
+
+Schema structure
+----------------
+
+YAML schema has the following conceptual sections. Most properties in the schema
+accept (or in fact require) a ``description`` sub-property documenting the defined
+object.
+
+Globals
+~~~~~~~
+
+There is a handful of global attributes such as the family name, version of
+the protocol, and additional C headers (used only for uAPI and C-compatible
+codegen).
+
+Global level also contains a handful of customization properties, like
+``attr-cnt-suffix`` which allow accommodating quirks of existing families.
+Those properties should not be used in new families.
+
+Attribute Spaces
+~~~~~~~~~~~~~~~~
+
+First of the main two sections is ``attribute-spaces``. This property contains
+information about netlink attributes of the family. All families have at least
+one attribute space, most have multiple. ``attribute-spaces`` is an array/list,
+with each entry describing a single space. The ``name`` of the space is not used
+in uAPI/C codegen, it's internal to the spec itself, used by operations and nested
+attributes to refer to a space.
+
+Each attribute space has properties used to render uAPI header enums. ``name-prefix``
+is prepended to the name of each attribute, allowing the attribute names to be shorter
+compared to the enum names in the uAPI.
+Optionally attribute space may contain ``enum-name`` if the uAPI header's enum should
+have a name. Most netlink uAPIs do not name attribute enums, the attribute names are
+heavily prefixed, which is sufficient.
+
+Most importantly each attribute space contains a list of attributes under the ``attributes``
+property. The properties of an attribute should look fairly familiar to anyone who ever
+wrote netlink code (``name``, ``type``, optional validation constraints like ``len`` and
+reference to the internal space for nests).
+
+Note that attribute spaces do not themselves nest, nested attributes refer to their internal
+space via a ``nested-attributes`` property, so the YAML spec does not resemble the format
+of the netlink messages directly.
+
+YAML spec may also contain fractional spaces - spaces which contain a ``subspace-of``
+property. Such spaces describe a section of a full space, allowing narrowing down which
+attributes are allowed in a nest or refining the validation criteria. Fractional spaces
+can only be used in nests. They are not rendered to the uAPI in any fashion.
+
+Operations and notifications
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+This section describes messages passed between the kernel and the user space.
+There are three types of entries in this section - operations, notifications
+and events.
+
+Notifications and events both refer to the asynchronous messages sent by the kernel
+to members of a multicast group. The difference between the two is that a notification
+shares its contents with a GET operation (the name of the GET operation is specified
+in the ``notify`` property). This arrangement is commonly used for notifications about
+objects where the notification carries the full object definition.
+
+Events are more focused and carry only a subset of information rather than full
+object state (a made up example would be a link state change event with just
+the interface name and the new link state).
+Events are considered less idiomatic for netlink and notifications
+should be preferred. After all, if the information in an event is sufficiently
+complete to be useful, it should also be useful enough to have a corresponding
+GET command.
+
+Operations describe the most common request - response communication. User
+sends a request and kernel replies. Each operation may contain any combination
+of the two modes familiar to netlink users - ``do`` and ``dump``.
+``do`` and ``dump`` in turn contain a combination of ``request`` and ``response``
+properties. If no explicit message with attributes is passed in a given
+direction (e.g. a ``dump`` which doesn't not accept filter, or a ``do``
+of a SET operation to which the kernel responds with just the netlink error code)
+``request`` or ``response`` section can be skipped. ``request`` and ``response``
+sections list the attributes allowed in a message. The list contains only
+the names of attributes from a space referred to by the ``attribute-space``
+property.
+
+An astute reader will notice that there are two ways of defining sub-spaces.
+A full fractional space with a ``subspace-of`` property and a de facto subspace
+created by list attributes for an operation. This is only for convenience.
+The abilities to refine the selection of attributes and change their definition
+afforded by the fractional space result in much more verbose YAML, and the full
+definition of a space (i.e. containing all attributes) is always required to render
+the uAPI header, anyway. So the per-operation attribute selection is a form of
+a shorthand.
+
+Multicast groups
+~~~~~~~~~~~~~~~~
+
+This section lists the multicast groups of the family, not much to be said.
-- 
2.37.1

